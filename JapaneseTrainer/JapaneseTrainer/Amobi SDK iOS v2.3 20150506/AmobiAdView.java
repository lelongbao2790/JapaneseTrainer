package com.mygdx.lib;

import org.robovm.apple.foundation.NSObjectProtocol;
import org.robovm.apple.uikit.UIView;
import org.robovm.apple.uikit.UIViewController;
import org.robovm.objc.ObjCRuntime;
import org.robovm.objc.annotation.Method;
import org.robovm.objc.annotation.NativeClass;
import org.robovm.objc.annotation.Property;
import org.robovm.rt.bro.ValuedEnum;
import org.robovm.rt.bro.annotation.Library;
import org.robovm.rt.bro.annotation.Pointer;

@Library(Library.INTERNAL)
@NativeClass
public class AmobiAdView extends UIView {
	static {ObjCRuntime.bind(AmobiAdView.class);}
	public enum BannerSize implements ValuedEnum {
		SizeFullScreen(0),
	    Size300x250(1),
	    Size320x50(2),
	    None(3);
		private final long n;
		private BannerSize(long n){
			this.n=n;
		}
		@Override
		public long value() {
			return n;
		}

	}
	public interface AmobiBannerDelegate extends NSObjectProtocol{
		@Method(selector="adViewLoadSuccess:")
		void adViewLoadSuccess(AmobiAdView amobiAdView);
		@Method(selector="adViewLoadError:")
		void adViewLoadError(AmobiAdView amobiAdView);
		@Method(selector="adViewClose:")
		void adViewClose(AmobiAdView amobiAdView);

	}
	@Method(selector="initWithBannerSize:")
	private native @Pointer long init(BannerSize bannerSize);
	
	public AmobiAdView(BannerSize bannerSize){
		super((SkipInit)null);
		initObject(init( bannerSize));
	}
	@Method(selector="setDelegate:")
	public native void setDelegate(AmobiBannerDelegate _delegate);
	
	@Method(selector="loadAd")
	public native void loadAd();
	
	@Method(selector="loadAdSize:")
	public native void loadAdSize(BannerSize bannerSize);
//	@eMethod(selector="setRootViewController:")
//	public native void setRootViewController(UIViewController viewController);
//	@Method(selector="hideBanner:")
//	public native void hideBanner();
//	
	
//	- (void) setDelegate:(id)_delegate;
//	- (void) hideBanner:(id)sender;
	


}
