package com.videojs{
    
    import com.videojs.events.VideoJSEvent;
    import com.videojs.events.VideoPlaybackEvent;
    import com.videojs.structs.ExternalErrorEventName;
    
    import flash.display.Bitmap;
    import flash.display.Loader;
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.events.StageVideoEvent;
    import flash.external.ExternalInterface;
    import flash.geom.Rectangle;
    import flash.media.StageVideo;
    import flash.net.URLRequest;
    import flash.system.LoaderContext;
    
    public class VideoJSView extends Sprite{
        
        private var _uiVideo:StageVideo;
        private var _uiBackground:Sprite;
        
        private var _model:VideoJSModel;
        
        public function VideoJSView(stage:Stage){
            
            _model = VideoJSModel.getInstance(stage);
            _model.addEventListener(VideoJSEvent.BACKGROUND_COLOR_SET, onBackgroundColorSet);
            _model.addEventListener(VideoJSEvent.STAGE_RESIZE, onStageResize);
            _model.addEventListener(VideoPlaybackEvent.ON_META_DATA, onMetaData);
            _model.addEventListener(VideoPlaybackEvent.ON_VIDEO_DIMENSION_UPDATE, onDimensionUpdate);
            
            _uiBackground = new Sprite();
            _uiBackground.graphics.beginFill(_model.backgroundColor, 1);
            _uiBackground.graphics.drawRect(0, 0, _model.stageRect.width, _model.stageRect.height);
            _uiBackground.graphics.endFill();
            _uiBackground.alpha = _model.backgroundAlpha;
            addChild(_uiBackground);
            _uiVideo = stage.stageVideos[0];
            _uiVideo.addEventListener(StageVideoEvent.RENDER_STATE, onStageVideoRender);
            
            _model.videoReference = _uiVideo;
            
        }
        
        private function onStageVideoRender(e:StageVideoEvent):void {
            ExternalInterface.call("console.log", "Decoder: " + e.status);
            sizeVideoObject();
        }

        private function sizeVideoObject():void{
            
            var __targetWidth:int, __targetHeight:int;
            var __targetY:int, __targetX:int;
            
            var __availableWidth:int = _model.stageRect.width;
            var __availableHeight:int = _model.stageRect.height;
            
            var __nativeWidth:int = 100;
            
            if(_model.metadata.width != undefined){
                __nativeWidth = Number(_model.metadata.width);
            }
            
            if(_uiVideo.videoWidth != 0){
                __nativeWidth = _uiVideo.videoWidth;
            }
            
            var __nativeHeight:int = 100;
            
            if(_model.metadata.width != undefined){
                __nativeHeight = Number(_model.metadata.height);
            }
            
            if(_uiVideo.videoWidth != 0){
                __nativeHeight = _uiVideo.videoHeight;
            }

            // first, size the whole thing down based on the available width
            __targetWidth = __availableWidth;
            __targetHeight = __targetWidth * (__nativeHeight / __nativeWidth);
            
            if(__targetHeight > __availableHeight){
                __targetWidth = __targetWidth * (__availableHeight / __targetHeight);
                __targetHeight = __availableHeight;
            }

            __targetX = Math.round((_model.stageRect.width - __targetWidth) / 2);
            __targetY = Math.round((_model.stageRect.height - __targetHeight) / 2);

            _uiVideo.viewPort = new Rectangle(__targetX, __targetY, __targetWidth, __targetHeight);

        }

        private function onBackgroundColorSet(e:VideoPlaybackEvent):void{
            _uiBackground.graphics.clear();
            _uiBackground.graphics.beginFill(_model.backgroundColor, 1);
            _uiBackground.graphics.drawRect(0, 0, _model.stageRect.width, _model.stageRect.height);
            _uiBackground.graphics.endFill();
        }
        
        private function onStageResize(e:VideoJSEvent):void{
            
            _uiBackground.graphics.clear();
            _uiBackground.graphics.beginFill(_model.backgroundColor, 1);
            _uiBackground.graphics.drawRect(0, 0, _model.stageRect.width, _model.stageRect.height);
            _uiBackground.graphics.endFill();
            sizeVideoObject();
        }
   
        private function onMetaData(e:VideoPlaybackEvent):void{        
            sizeVideoObject();
        }

        private function onDimensionUpdate(e:VideoPlaybackEvent):void{
            sizeVideoObject();
        }
        
    }
}
