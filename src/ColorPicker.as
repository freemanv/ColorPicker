package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	[SWF(width="1000", height="620", backgroundColor="#ffffff", frameRate="30")]
	public class ColorPicker extends Sprite
	{
		var canvas:Sprite;
		var Hue:int;
		var Saturation:int;
		var Lightness:int;
		var R:int;
		var G:int;
		var B:int;
		var hexString:String;
		var stage_width:int;
		var stage_height:int;
		var stop:Boolean;  /// test if the user click the mouse to freeze the color
		
		public function ColorPicker()
		{
			Lightness = 50;
			hexString = new String();
			stop = false;
			stage_width = 1000;
			stage_height = 620;
			
			canvas = new Sprite();

			canvas.graphics.beginFill(0xffffff);
			canvas.graphics.drawRect(0,0,1200,1000);
			canvas.graphics.endFill();
			addChild(canvas);
			
			this.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			this.addEventListener(MouseEvent.MOUSE_WHEEL,onWheelRoll);
			this.addEventListener(MouseEvent.CLICK,onMouseClick);
		}
		
		private function onMouseClick(Event:MouseEvent):void
		{
            if(stop)
			{
				stop = !stop;
				Hue = int(mouseX*Number(360)/stage_width);
				Saturation = int(mouseY*Number(100)/stage_height);
				updataCanvas();
			}
			else
			{
				stop = !stop;
			}
		}
				
		private function onWheelRoll(Event:MouseEvent):void
		{
			///  Event.delta  = 3 (flash的默认设置)
			if(!stop)
			{
				/// add or subtract the lightness
				Lightness += Event.delta/3 ;
				
				// clamp the lightness
				if(Lightness<=0)
					Lightness = 0;
				if(Lightness>=100)
					Lightness = 100;
				
				updataCanvas();
			}
		}
		
		private function updataCanvas()
		{
			/// compute the rgb value according to the relevant hsl value
			HSLtoRGB();	
			hexString = getHexString();						
			
			canvas.graphics.clear();
			canvas.graphics.beginFill(uint(hexString));
			canvas.graphics.drawRect(0,0,stage_width,stage_height);
			canvas.graphics.endFill();
		}
		
		private function onMouseMove(Event:MouseEvent):void
		{
			if(!stop)
			{
				Hue = int(mouseX*Number(360)/stage_width);
				Saturation = int(mouseY*Number(100)/stage_height);
				updataCanvas();
			}
		}
		
		private function aux_getHexString(value:int):String
		{
			var hexstring:String = new String;
			hexstring = "";
			var result:Array = new Array();	
			var leftbit:int;
			var rightbit:int;
			
			result[7] = value%2;
			value /= 2;
			result[6] = value%2;
			value /= 2;
			result[5] = value%2;
			value /= 2;
			result[4] = value%2;
			value /= 2;
			result[3] = value%2;
			value /= 2;
			result[2] = value%2;
			value /= 2;
			result[1] = value%2;
			value /= 2;
			result[0] = value%2;
			value /= 2;
			
			leftbit = result[0]*8+result[1]*4+result[2]*2+result[3];		
			if(leftbit<10)
				hexstring += leftbit.toString();
			else
			{
				switch(leftbit)
				{
					case 10:
						hexstring += "A"
						break;
					case 11:
						hexstring += "B"
						break;
					case 12:
						hexstring += "C"
						break;
					case 13:
						hexstring += "D"
						break;
					case 14:
						hexstring += "E"
						break;
					case 15:
						hexstring += "F"
						break;					
				}
			}
			
			rightbit = result[4]*8+result[5]*4+result[6]*2+result[7];			
			if(rightbit<10)
				hexstring += rightbit.toString();
			else
			{
				switch(rightbit)
				{
					case 10:
						hexstring += "A"
						break;
					case 11:
						hexstring += "B"
						break;
					case 12:
						hexstring += "C"
						break;
					case 13:
						hexstring += "D"
						break;
					case 14:
						hexstring += "E"
						break;
					case 15:
						hexstring += "F"
						break;					
				}
			}
						
			return hexstring;				
		}
		
		private function getHexString():String
		{
            var hexstring:String = new String;
			hexstring = "0x";
			hexstring += aux_getHexString(R);
			hexstring += aux_getHexString(G);
			hexstring += aux_getHexString(B);

			return hexstring;			
		}
		
		/// hsl 取值范围是 0~1
		private function HSLtoRGB():void
		{
			 var temp1:Number;
			 var temp2:Number;
			 
	         if( Saturation == 0 )
			 {
				 R = (Number(Lightness)/100)*255;
				 G = (Number(Lightness)/100)*255;
				 B = (Number(Lightness)/100)*255;
			 }
			 else
			 {			 
				 if((Number(Lightness)/100)<0.5)
				 {
					 temp2=(Number(Lightness)/100)*(1.0+(Number(Saturation)/100));
				 }
				 else
				 {
					 temp2=(Number(Lightness)/100)+(Number(Saturation)/100)-(Number(Lightness)/100)*(Number(Saturation)/100);
				 }
				 
				 temp1 = 2.0 * (Number(Lightness)/100) - temp2;
				 
				 R = 255.0 * testHue(temp1, temp2, (Number(Hue)/360) + (1.0 / 3.0));
				 G = 255.0 * testHue(temp1, temp2, (Number(Hue)/360));
				 B = 255.0 * testHue(temp1, temp2, (Number(Hue)/360) - (1.0 / 3.0));				 
			 }			 			 
		}
		
		private function testHue(v1:Number,v2:Number,vH:Number):Number
		{
			if (vH < 0) vH += 1;
			if (vH > 1) vH -= 1;
			if (6.0 * vH < 1) return v1 + (v2 - v1) * 6.0 * vH;
			if (2.0 * vH < 1) return v2;
			if (3.0 * vH < 2) return v1 + (v2 - v1) * ((2.0 / 3.0) - vH) * 6.0;
			return (v1);
		}
		
	}
}