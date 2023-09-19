require 'minitest/autorun'

class Client
  def initialize
    # Arbitrary time spent creating object
    sleep(0.0001)
  end
end

class Provider
  def self.client_not_threadsafe
    @client ||= Client.new
  end

  def self.client_threadsafe
    return @client if @client

    CLIENT_LOCK.synchronize do
      @client = Client.new
      return @client
    end
  end
  CLIENT_LOCK = Mutex.new
  private_constant :CLIENT_LOCK
end

class ProviderTest < Minitest::Test
  def test_client_not_threadsafe
    num_threads = 10
    mutex = Mutex.new
    client_object_ids = []
    threads = num_threads.times.map do
      Thread.new do
        client = Provider.client_not_threadsafe
        mutex.synchronize { client_object_ids << client.object_id }
      end
    end
    threads.each(&:join)
    assert_equal client_object_ids.uniq.count, 1, "Expected to fail because not threadsafe"
  end

  def test_client_threadsafe
    num_threads = 10
    mutex = Mutex.new
    client_object_ids = []
    threads = num_threads.times.map do
      Thread.new do
        client = Provider.client_threadsafe
        mutex.synchronize { client_object_ids << client.object_id }
      end
    end
    threads.each(&:join)
    # Will pass if underlying code is actually thread-safe
    assert_equal client_object_ids.uniq.count, 1
  end
end
