package com.videojs{
    
    import flash.display.Sprite;
    import flash.display.Stage;
	
    public class VideoJSApp extends Sprite{
        
        private var _uiView:VideoJSView;
        private var _model:VideoJSModel;
        
        public function VideoJSApp(stage:Stage){
            
            _model = VideoJSModel.getInstance(stage);

            _uiView = new VideoJSView(stage);
            addChild(_uiView);

        }
        
        public function get model():VideoJSModel{
            return _model;
        }
        
    }
}