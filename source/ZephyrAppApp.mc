import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Communications;

// Application class - this must be defined in a separate file named ZephyrAppApp.mc
class ZephyrAppApp extends Application.AppBase {
    function initialize() {
        AppBase.initialize();
        System.println("initialize() in ZephyrAppApp");
    }
    
    // This function returns the initial view (your data field)
    function getInitialView() {
        System.println("getInitialView()");

        return [new ZephyrApp()];
    }
    
}

// A separate function at the global scope that's required
function getApp() as ZephyrAppApp {
    System.println("getApp() as ZephyrAppApp");
    return Application.getApp() as ZephyrAppApp;
}