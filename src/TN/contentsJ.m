TNtoolbox contents


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sub-toolbox
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
BitsCalibration:            Bits++�̃L�����u���[�V�����iColorCAL�APR650�Ȃǎg�p�j
NormalStair:                �K�i�@�葱��
TNColorConversionToolbox:   �F�ϊ�


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sound etc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MakeSoundSet:  �����Ɏg�����̍쐬�i�U��ށAsound�֐��p�j
ClearSoundSet: MakeSoundSet�ō쐬�������ϐ��̏���


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Bits++ gamma linealization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rgb2RGB_LUT:  �L�����u���[�V������.lut�t�@�C�����g���Argb(0-1)�Ɛ��`�ƂȂ�RGB(1-65536)������i������ƒᑬ�A���x���j�B
rgb2RGB_iLUT: �L�����u���[�V������.ilut�t�@�C�����g���Argb(0-1)�Ɛ��`�ƂȂ�RGB(1-65536)������i�ō����A������Ɛ��x��j�B
rgb2RGB_fitting: �L�����u���[�V������.ilp�t�@�C�����g���Argb(0-1)�Ɛ��`�ƂȂ�RGB(1-65536)������i�Œᑬ�A���x��j�B



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Bits++ etc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ResetBits:      Bits++�̃��Z�b�g�iT-Lock�󂯓���ON�CCLUT linealization�j
ResetMono:      Mono++�̃��Z�b�g�i�����K���}�C��OFF�j
adaptationBits: Bits++�ɂ������O�̏����h���掦
CRTwarmupBits:  Bits++�ɂ��CRT�g�@


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
VSG etc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
CRTwarmupVSG:           VSG�ɂ��CRT�g�@
CRTwarmupVSG_BPEL:      VSG�ɂ��CRT�g�@�ivsg�֐����g��BPEL�p�j
adaptationVSG_BPEL.m:   VSG�ɂ������O�̏����h���掦�i��������@�\�j


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
log
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
log2linear: log dimension��0-1��linear dimension��0-1�ɕϊ�
linear2log: linear dimension��0-1��log dimension��0-1�ɕϊ�
		

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mathmatical 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FindKindNum: ����z��ɂ���v�f�̎�ސ��Ƃ�������ׂ��z����o��


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Experiment initialization, filename, etc...
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
InitExp:                �����������B�f�[�^�t�@�C�����A�t�H���_���A����Ȃǂ��o��
SaveExpVariables:       InitExp�̏����g���āA�ϐ����t�@�C���ɕۑ�
FindCurrentMatFileName: �ߋ��̓�����{�t�@�C���O��mat�t�@�C����T�����A���݂̐���ƃt�@�C�������o��
SetSuccsessiveFileName: ��{�t�@�C�����Ɛ��㐔����A�t�@�C�������o��

deg2cm:                 ���p��cm�Ɍv�Z
cm2deg:                 cm�����p�Ɍv�Z

created by Takehiro Nagai on 12/20/2007
modified by Takehiro Nagai on 05/20/2010
