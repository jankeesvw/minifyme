package {
	import data.Constants;
	
	import utils.FileValidator;
	
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeDragManager;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.NativeDragEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLRequest;		

	/**
	 * @author jankeesvw
	 */
	public class MinifyMe extends Sprite {

		private var sp:Sprite;
		private var newCompleteCSS:String;
		private var loader:Loader;		private var newFileName:String;

		public function MinifyMe() {
			newCompleteCSS = "";
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			loader = new Loader();
			var url:String = "embedded/design.jpg";
			var urlReq:URLRequest = new URLRequest(url);
			loader.load(urlReq);
			addChild(loader);
        	
			sp = new Sprite();
			sp.graphics.beginFill(0xff0000,0);
			sp.graphics.drawRect(44,57,88,88);
			sp.graphics.endFill();
			this.addChild(sp);
        	
			sp.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER,dragEnter);
			sp.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP,dragDrop);
		}

		private function dragEnter(event:NativeDragEvent):void {
			var files:Array = event.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
			if(FileValidator.filetype(files,Constants.accepted_file_extensions)) {
				newCompleteCSS = "";
				NativeDragManager.acceptDragDrop(sp);
				var choseFileExtension:String = File(files[0]).extension;
				var choseFilePath:String = File(files[0]).parent.nativePath;
                newFileName = choseFilePath + "/" + "pack." + choseFileExtension;
			}
		}

		private function dragDrop(event:NativeDragEvent):void {
			var files:Array = event.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
			var leni:uint = files.length;
			for (var i:uint = 0;i < leni; i++) {
				var file:File = files[i];
				
				/* read file */
				var fileStream:FileStream = new FileStream();
				fileStream.open(file,FileMode.READ);
				var str:String = fileStream.readMultiByte(file.size,File.systemCharset);
                
				/* append text */
				newCompleteCSS += str;		
			}
			
			newCompleteCSS = newCompleteCSS.split("\n").join("");
			newCompleteCSS = newCompleteCSS.split("\r").join("");
			newCompleteCSS = newCompleteCSS.split("\t").join("");
			
			saveFile();
		}

		private function saveFile():void {
			var file:File = new File(newFileName);
			
			// Create a file stream to write stuff to the file.
			var stream:FileStream = new FileStream();
			// Open the file stream.
			stream.open(file,FileMode.WRITE);
			// Write stuff to the file.
			stream.writeUTFBytes(newCompleteCSS);
			// Close the file stream.
			stream.close();

			file = null;
			stream = null;
		}
	}
}
