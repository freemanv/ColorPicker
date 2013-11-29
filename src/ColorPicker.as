package
{
	import flash.display.BlendMode;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	
	[SWF(width="1000", height="620", backgroundColor="#ffffff", frameRate="30")]

	
	public class ColorPicker extends Sprite
	{
		
		//[Embed(source="consola.ttf", fontName="consola", embedAsCFF="false", unicodeRange="U+61,U+62,U+7b80,U+4f53,U+45,U+ff1b,U+3002,U+2e")]
		[Embed(source="consola.ttf", fontName="consola", embedAsCFF="false",mimeType="application/x-font-truetype")]
		static public var ConsolaFont:Class;
		
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
		var Hint:TextField;
		var RGB:TextField;
		var HSL:TextField;
		var HEX:TextField;
		
		public function ColorPicker()
		{						
			
			Lightness = 50;
			hexString = new String();
			stop = false;
			stage_width = 1000;
			stage_height = 620;
			
			/// register the font
			//Font.registerFont(ConsolaFont);
			
			
			canvas = new Sprite();
			Hint = new TextField();
			RGB = new TextField();
			HSL = new TextField();
			HEX = new TextField();			

						
			// initial the start text
			var textfmt:TextFormat = new TextFormat();
			textfmt.color = 0xffffff;
			textfmt.size = 20;
			textfmt.font = "consola";
			Hint = new TextField();
			Hint.embedFonts = true;
			Hint.x = stage_width/2-700/2+ 300;
			Hint.y = stage_height-150+15;
			Hint.text = "-Click anywhere to lock color - Scroll to change luminosity-";
			Hint.alpha = 0.5;
			Hint.setTextFormat(textfmt);
			Hint.autoSize = TextFieldAutoSize.CENTER;

			
			
			/// initial the canvas
			canvas.graphics.beginFill(0xffffff);
			canvas.graphics.drawRect(0,0,1200,1000);
			canvas.graphics.endFill();
			addChild(canvas);
			canvas.addChild(Hint);
			canvas.addChild(RGB);
			canvas.addChild(HSL);
			canvas.addChild(HEX);
			
			
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
				updataTag();
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
				updataTag();
			}
		}
		
		private function updataTag():void
		{
			/// 因为 updataTag的调用在updataCanvas之后，所以不用调用graphic.clear()
			
			canvas.graphics.beginFill(0x333333,0.2);
			canvas.graphics.drawRoundRect(stage_width/2-700/2,stage_height-150,700,100,65,65);
			canvas.graphics.endFill();

			var textfmt:TextFormat = new TextFormat();
			textfmt.color = 0xffffff;
			textfmt.size = 26;
			textfmt.font = "consola";
			RGB.embedFonts = true;
			RGB.x = stage_width/2-700/2+ 15;
			RGB.y = stage_height-150+45;
			RGB.text = "rgb("+R+","+G+","+B+")";
			RGB.alpha = 0.5;
			RGB.setTextFormat(textfmt);
			RGB.autoSize = TextFieldAutoSize.CENTER;
			
			HEX.embedFonts = true;
			HEX.x = stage_width/2-700/2+ 255;
			HEX.y = stage_height-150+45;
			HEX.text = "hex(#"+hexString.substr(2)+")";
			HEX.alpha = 0.5;
			HEX.setTextFormat(textfmt);
			HEX.autoSize = TextFieldAutoSize.CENTER;
			
			HSL.embedFonts = true;
			HSL.x = stage_width/2-700/2+ 455;
			HSL.y = stage_height-150+45;
			HSL.text = "hsl("+Hue+","+Saturation+"%,"+Lightness+"%)";
			HSL.alpha = 0.5;
			HSL.setTextFormat(textfmt);
			HSL.autoSize = TextFieldAutoSize.CENTER;
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
				updataTag();
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