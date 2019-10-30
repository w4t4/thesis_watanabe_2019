TNtoolbox contents


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sub-toolbox
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
BitsCalibration:            Bits++のキャリブレーション（ColorCAL、PR650など使用）
NormalStair:                階段法手続き
TNColorConversionToolbox:   色変換


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sound etc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MakeSoundSet:  実験に使う音の作成（６種類、sound関数用）
ClearSoundSet: MakeSoundSetで作成した音変数の消去


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Bits++ gamma linealization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rgb2RGB_LUT:  キャリブレーションの.lutファイルを使い、rgb(0-1)と線形となるRGB(1-65536)を決定（ちょっと低速、精度高）。
rgb2RGB_iLUT: キャリブレーションの.ilutファイルを使い、rgb(0-1)と線形となるRGB(1-65536)を決定（最高速、ちょっと精度低）。
rgb2RGB_fitting: キャリブレーションの.ilpファイルを使い、rgb(0-1)と線形となるRGB(1-65536)を決定（最低速、精度低）。



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Bits++ etc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ResetBits:      Bits++のリセット（T-Lock受け入れON，CLUT linealization）
ResetMono:      Mono++のリセット（自動ガンマ修正OFF）
adaptationBits: Bits++による実験前の順応刺激呈示
CRTwarmupBits:  Bits++によるCRT暖機


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
VSG etc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
CRTwarmupVSG:           VSGによるCRT暖機
CRTwarmupVSG_BPEL:      VSGによるCRT暖機（vsg関数を使うBPEL用）
adaptationVSG_BPEL.m:   VSGによる実験前の順応刺激呈示（ただし低機能）


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
log
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
log2linear: log dimensionの0-1をlinear dimensionの0-1に変換
linear2log: linear dimensionの0-1をlog dimensionの0-1に変換
		

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mathmatical 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FindKindNum: ある配列にある要素の種類数とそれらを並べた配列を出力


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Experiment initialization, filename, etc...
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
InitExp:                実験初期化。データファイル名、フォルダ名、世代などを出力
SaveExpVariables:       InitExpの情報を使って、変数をファイルに保存
FindCurrentMatFileName: 過去の同じ基本ファイル前のmatファイルを探索し、現在の世代とファイル名を出力
SetSuccsessiveFileName: 基本ファイル名と世代数から、ファイル名を出力

deg2cm:                 視角をcmに計算
cm2deg:                 cmを視角に計算

created by Takehiro Nagai on 12/20/2007
modified by Takehiro Nagai on 05/20/2010
