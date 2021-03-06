require 'dl/import'

class LiveMidi
  module C
    extend DL::Importer
    dlload 'winmm'
    
    extern "int midiOutOpen(HDMIDIOUT*, int, int, int, int)"
    extern "int midiOutClose(int)"
    extern "int midiOutShortMsg(int,int)"
  end

  add_hook_for :initialize, :open
  def open
    #~ @device = DL.malloc(DL.sizeof('I'))
    @device = DL::CPtr.new(DL.malloc(DL::SIZEOF_INT),DL::SIZEOF_INT)
    C.midiOutOpen(@device, -1, 0, 0, 0)
  end

  def close
    C.midiOutClose(device_pointer)
  end

  def message(*to_send)
    message = 0
    to_send.each_with_index do |send, index| 
      message += (send << (8 * index))
    end
    C.midiOutShortMsg(device_pointer, message)
  end

  def device_pointer
    open unless @device
    @device.ptr.to_i
  end
end
