package com.mygdx.lib;

import org.robovm.apple.foundation.NSObjectProtocol;
import org.robovm.apple.uikit.UIView;
import org.robovm.apple.uikit.UIViewController;
import org.robovm.objc.ObjCRuntime;
import org.robovm.objc.annotation.Method;
import org.robovm.objc.annotation.NativeClass;
import org.robovm.rt.bro.annotation.Library;
@Library(Library.INTERNAL)
@NativeClass
public class AmobiVideoAd extends UIView{
	static {ObjCRuntime.bind(AmobiAdView.class);}

	@Method(selector="prepare")
	public native void prepare();
	@Method(selector="playVideo:")
	public native void playVideo(UIViewController rootViewController);	
	@Method(selector="setDelegate:")
	public native void setDelegate(AmbVideoAdDelegate delegate);	
	public interface AmbVideoAdDelegate extends NSObjectProtocol{
		@Method(selector="onAdAvailable:")
		void onAdAvailable(AmobiVideoAd amobiAdView);
		@Method(selector="onAdStarted:")
		void onAdStarted(AmobiVideoAd amobiAdView);
		@Method(selector="onAdFinished:")
		void onAdFinished(AmobiVideoAd amobiAdView);
		@Method(selector="onPrepareError:")
		void onPrepareError(AmobiVideoAd amobiAdView);
	}
	
	
}

