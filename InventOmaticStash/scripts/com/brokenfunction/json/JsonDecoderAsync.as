package com.brokenfunction.json
{
   import flash.errors.EOFError;
   import flash.events.IEventDispatcher;
   import flash.events.ProgressEvent;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class JsonDecoderAsync
   {
      
      private static const _charConvert:ByteArray = new ByteArray();
      
      private var _input:IDataInput;
      
      private var _result:*;
      
      private var _buffer:ByteArray = new ByteArray();
      
      public var parseTopLevelNumbers:Boolean = true;
      
      public var trailingByte:int = -1;
      
      private var _stack:Array = [-1];
      
      public function JsonDecoderAsync(input:*, autoSubscribe:Boolean = true)
      {
         super();
         if(input is IDataInput)
         {
            _input = input as IDataInput;
         }
         else
         {
            if(!(input is String))
            {
               throw new Error("Unexpected input <" + input + ">");
            }
            var bytes:ByteArray = new ByteArray();
            bytes.writeUTFBytes(input as String);
            bytes.position = 0;
            _input = bytes;
         }
         _input.endian = "bigEndian";
         if(!_charConvert.length)
         {
            _charConvert.length = 256;
            _charConvert[34] = 34;
            _charConvert[92] = 92;
            _charConvert[47] = 47;
            _charConvert[98] = 8;
            _charConvert[102] = 12;
            _charConvert[110] = 10;
            _charConvert[114] = 13;
            _charConvert[116] = 9;
         }
         if(autoSubscribe)
         {
            var dispatch:IEventDispatcher = input as IEventDispatcher;
            if(dispatch)
            {
               dispatch.addEventListener(ProgressEvent.SOCKET_DATA,progressHandler,false,0,true);
               dispatch.addEventListener(ProgressEvent.PROGRESS,progressHandler,false,0,true);
            }
            process();
         }
      }
      
      private function progressHandler(e:ProgressEvent) : void
      {
         process();
      }
      
      private function isWhitespace(char:int) : Boolean
      {
         return char === 32 || char === 13 || char === 10 || char === 9;
      }
      
      public function get result() : *
      {
         return _result;
      }
      
      public function process(limit:uint = 0) : Boolean
      {
         var startAvailable:uint;
         var result:Object;
         var char:int;
         var continueMainloop:Boolean;
         if(_stack.length <= 0)
         {
            return true;
         }
         startAvailable = uint(_input.bytesAvailable);
         try
         {
            while(_stack.length > 0)
            {
               switch(_stack[_stack.length - 1])
               {
                  case -1:
                     _stack[_stack.length - 1] = _input.readUnsignedByte();
                     continue;
                  case 34:
                     continueMainloop = false;
                     if(limit > 0)
                     {
                        while((char = int(_input.readUnsignedByte())) !== 34)
                        {
                           if(char === 92)
                           {
                              _stack[_stack.length - 1] = 512;
                              continueMainloop = true;
                              break;
                           }
                           _buffer.writeByte(char);
                           if(startAvailable - _input.bytesAvailable >= limit)
                           {
                              return false;
                           }
                        }
                     }
                     else
                     {
                        while((char = int(_input.readUnsignedByte())) !== 34)
                        {
                           if(char === 92)
                           {
                              _stack[_stack.length - 1] = 512;
                              continueMainloop = true;
                              break;
                           }
                           _buffer.writeByte(char);
                        }
                     }
                     if(!continueMainloop)
                     {
                        _buffer.position = 0;
                        result = _buffer.readUTFBytes(_buffer.length);
                        _buffer.length = 0;
                        _stack.pop();
                     }
                     continue;
                  case 512:
                     if((char = int(_input.readUnsignedByte())) !== 117)
                     {
                        char = int(_charConvert[char]);
                        if(char === 0)
                        {
                           throw new Error("Unexpected escape character");
                        }
                        _stack[_stack.length - 1] = 34;
                        _buffer.writeByte(char);
                        continue;
                     }
                     _stack[_stack.length - 1] = 513;
                  case 513:
                     if(_input.bytesAvailable < 4)
                     {
                        return false;
                     }
                     char = int(parseInt(_input.readUTFBytes(4),16));
                     if(char <= 127)
                     {
                        _buffer.writeByte(char);
                     }
                     else if(char < 2047)
                     {
                        _buffer.writeShort(0xC080 | char << 2 & 0x1F00 | char & 0x3F);
                     }
                     else
                     {
                        _buffer.writeByte(0xE0 | char >> 12 & 0x0F);
                        _buffer.writeShort(0x8080 | char << 2 & 0x3F00 | char & 0x3F);
                     }
                     _stack[_stack.length - 1] = 34;
                     continue;
                  case 123:
                     if((char = int(_input.readUnsignedByte())) === 125)
                     {
                        result = {};
                        _stack.pop();
                     }
                     else
                     {
                        if(char !== 34)
                        {
                           if(!isWhitespace(char))
                           {
                              throw new Error("Unexpected character 0x" + char.toString(16) + " at the start of object");
                           }
                           continue;
                        }
                        _stack[_stack.length - 1] = {};
                        _stack[_stack.length] = null;
                        _stack[_stack.length] = 768;
                        _stack[_stack.length] = 34;
                     }
                     continue;
                  case 768:
                     _stack[_stack.length - 2] = result;
                     _stack[_stack.length - 1] = 769;
                  case 769:
                     if((char = int(_input.readUnsignedByte())) !== 58)
                     {
                        if(!isWhitespace(char))
                        {
                           throw new Error("Expected : during object parsing, not 0x" + char.toString(16));
                        }
                     }
                     else
                     {
                        _stack[_stack.length - 1] = 770;
                        _stack[_stack.length] = -1;
                     }
                     continue;
                  case 770:
                     _stack[_stack.length - 3][_stack[_stack.length - 2]] = result;
                     _stack[_stack.length - 1] = 771;
                  case 771:
                     if((char = int(_input.readUnsignedByte())) === 44)
                     {
                        _stack[_stack.length - 1] = 772;
                        if(limit > 0 && startAvailable - _input.bytesAvailable >= limit)
                        {
                           return false;
                        }
                        break;
                     }
                     if(char === 125)
                     {
                        result = _stack[_stack.length - 3];
                        _stack.length -= 3;
                     }
                     else if(!isWhitespace(char))
                     {
                        throw new Error("Expected , or } during object parsing, not 0x" + char.toString(16));
                     }
                     continue;
                  case 772:
                     break;
                  case 91:
                     if((char = int(_input.readUnsignedByte())) === 93)
                     {
                        result = [];
                        _stack.pop();
                     }
                     else if(!isWhitespace(char))
                     {
                        _stack[_stack.length - 1] = [];
                        _stack[_stack.length] = 1024;
                        _stack[_stack.length] = char;
                     }
                     continue;
                  case 1024:
                     (_stack[_stack.length - 2] as Array).push(result);
                     _stack[_stack.length - 1] = 1025;
                  case 1025:
                     if((char = int(_input.readUnsignedByte())) === 44)
                     {
                        _stack[_stack.length - 1] = 1024;
                        _stack[_stack.length] = -1;
                        if(limit > 0 && startAvailable - _input.bytesAvailable >= limit)
                        {
                           return false;
                        }
                     }
                     else
                     {
                        if(char !== 93)
                        {
                           if(!isWhitespace(char))
                           {
                              throw new Error("Expected , or ] during array parsing, not 0x" + char.toString(16));
                           }
                           continue;
                        }
                        result = _stack[_stack.length - 2];
                        _stack.length -= 2;
                     }
                     continue;
                  case 116:
                     if(_input.bytesAvailable < 3)
                     {
                        return false;
                     }
                     if(!(_input.readShort() === 29301 && _input.readUnsignedByte() === 101))
                     {
                        throw new Error("Expected \"true\"");
                     }
                     result = true;
                     _stack.pop();
                     continue;
                  case 102:
                     if(_input.bytesAvailable < 4)
                     {
                        return false;
                     }
                     if(_input.readInt() !== 1634497381)
                     {
                        throw new Error("Expected \"false\"");
                     }
                     result = false;
                     _stack.pop();
                     continue;
                  case 110:
                     if(_input.bytesAvailable < 3)
                     {
                        return false;
                     }
                     if(!(_input.readShort() === 30060 && _input.readUnsignedByte() === 108))
                     {
                        throw new Error("Expected \"null\"");
                     }
                     result = null;
                     _stack.pop();
                     continue;
                  case 256:
                     while((char = int(_input.readUnsignedByte())) !== 93 && char !== 125 && char !== 44)
                     {
                        _buffer.writeByte(char);
                     }
                     _buffer.position = 0;
                     result = Number(_buffer.readUTFBytes(_buffer.length));
                     _buffer.length = 0;
                     if(_stack[_stack.length - 2] === 770)
                     {
                        if(char === 44)
                        {
                           _stack[_stack.length - 4][_stack[_stack.length - 3]] = result;
                           _stack.pop();
                           _stack[_stack.length - 1] = 772;
                        }
                        else
                        {
                           if(char !== 125)
                           {
                              throw new Error("Unexpected ] while parsing object");
                           }
                           _stack[_stack.length - 4][_stack[_stack.length - 3]] = result;
                           result = _stack[_stack.length - 4];
                           _stack.length -= 4;
                        }
                     }
                     else if(_stack[_stack.length - 2] === 1024)
                     {
                        if(char === 44)
                        {
                           (_stack[_stack.length - 3] as Array).push(result);
                           _stack[_stack.length - 1] = -1;
                        }
                        else
                        {
                           if(char !== 93)
                           {
                              throw new Error("Unexpected } while parsing array");
                           }
                           (_stack[_stack.length - 3] as Array).push(result);
                           result = _stack[_stack.length - 3];
                           _stack.length -= 3;
                        }
                     }
                     continue;
                  case 13:
                  case 10:
                  case 9:
                  case 32:
                     while((char = int(_input.readUnsignedByte())) === 32 || char === 13 || char === 10 || char === 9)
                     {
                     }
                     _stack[_stack.length - 1] = char;
                     continue;
                  case 257:
                     while(_input.bytesAvailable)
                     {
                        if((char = int(_input.readUnsignedByte())) >= 48 && char <= 57 || char === 101 || char === 69 || char === 46 || char === 43 || char === 45)
                        {
                           _buffer.writeByte(char);
                        }
                        else
                        {
                           trailingByte = char;
                           _buffer.position = 0;
                           result = Number(_buffer.readUTFBytes(_buffer.length));
                           _buffer.length = 0;
                           _stack.pop();
                        }
                     }
                     _buffer.position = 0;
                     _result = Number(_buffer.readUTFBytes(_buffer.length));
                     return false;
                  default:
                     char = int(_stack[_stack.length - 1]);
                     if(!(char === 45 || char >= 48 && char <= 57))
                     {
                        throw new Error("Unexpected character 0x" + char.toString(16) + ", expecting a value");
                     }
                     if(_stack.length <= 1)
                     {
                        if(!parseTopLevelNumbers)
                        {
                           throw new Error("Top level number encountered");
                        }
                        _stack[_stack.length - 1] = 257;
                     }
                     else
                     {
                        _stack[_stack.length - 1] = 256;
                     }
                     _buffer.writeByte(char);
                     continue;
               }
               if((char = int(_input.readUnsignedByte())) === 34)
               {
                  _stack[_stack.length - 1] = 768;
                  _stack[_stack.length] = 34;
               }
               else if(!isWhitespace(char))
               {
                  throw new Error("Expected \" during object parsing, not 0x" + char.toString(16));
               }
            }
         }
         catch(e:EOFError)
         {
            return false;
         }
         catch(e:Error)
         {
            _stack.length = 0;
            throw e;
         }
         if(_stack.length <= 0)
         {
            _result = result;
            return true;
         }
         return false;
      }
   }
}

