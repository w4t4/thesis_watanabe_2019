function C=tonemap_and_gamma(XYZ,lw,ccmat,LUT)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%XYZの画像をトーンマッピング、ガンマ補正をかけたRGB色空間に変換する。
%具体的な手順はXYZからu'v'Lに変換⇒トーンマッピングを行う⇒XYZに再変換⇒rgbに変換⇒ガンマ補正をかけてRGBに変換
%トーンマッピングはReinhard関数を用いる。
%
%パラメータ
%XYZにXYZ(W,H,3)の行列
%lwにReinhardの係数
%scaleにスケーリング係数
%xyz2rgbにキャリブレーションで作成したXYZ2rgbの3*3行列
%lutにキャリブレーションで作成したガンマ関数のlutファイルを読み込んだもの
%を入れる。
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[xy(1),xy(2),~]=size(XYZ);

%%XYZ to u'v'L%%%
Cform=makecform('xyz2upvpl');
C= applycform(XYZ,Cform);

%%トーンマップ%%%
C = wTonemap(C,10,ccmat);


%%%u'v'L to XYZ%%%
Cform2=makecform('upvpl2xyz');
D= applycform(C,Cform2);

% convert xyY to RGB
xyY = reshape(D,[],3)';


%%%XYZ to rgb%%%
rgb = XYZ2rgb(xyY, ccmat);

% gamma correction: rgb to RGB(for the monitor)
RGB = uint8(rgb2RGB_LUT(rgb',LUT)/257);

% array reshape 3*(x*y) to x,y,3(RGB)
C=reshape(RGB,xy(1),xy(2),3);

imshow(C);

end
