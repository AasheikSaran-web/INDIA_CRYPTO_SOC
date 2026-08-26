module apb_uart(CLK, RSTN, PSEL, PENABLE, PWRITE, PADDR, PWDATA, PRDATA, PREADY, PSLVERR, INT, OUT1N, OUT2N, RTSN, DTRN, CTSN, DSRN, DCDN, RIN, SIN, SOUT
);
  input CLK;
  wire CLK;
  input RSTN;
  wire RSTN;
  input PSEL;
  wire PSEL;
  input PENABLE;
  wire PENABLE;
  input PWRITE;
  wire PWRITE;
  input [2:0] PADDR;
  wire [2:0] PADDR;
  input [31:0] PWDATA;
  wire [31:0] PWDATA;
  output [31:0] PRDATA;
  wire [31:0] PRDATA;
  output PREADY;
  wire PREADY;
  output PSLVERR;
  wire PSLVERR;
  output INT;
  wire INT;
  output OUT1N;
  wire OUT1N;
  output OUT2N;
  wire OUT2N;
  output RTSN;
  wire RTSN;
  output DTRN;
  wire DTRN;
  input CTSN;
  wire CTSN;
  input DSRN;
  wire DSRN;
  input DCDN;
  wire DCDN;
  input RIN;
  wire RIN;
  input SIN;
  wire SIN;
  output SOUT;
  wire SOUT;
  wire [15:0] _0000_;
  wire _0001_;
  wire _0002_;
  wire _0003_;
  wire _0004_;
  wire _0005_;
  wire _0006_;
  wire _0007_;
  wire _0008_;
  wire _0009_;
  wire _0010_;
  wire _0011_;
  wire _0012_;
  wire _0013_;
  wire _0014_;
  wire _0015_;
  wire _0016_;
  wire _0017_;
  wire _0018_;
  wire _0019_;
  wire _0020_;
  wire _0021_;
  wire _0022_;
  wire _0023_;
  wire _0024_;
  wire _0025_;
  wire _0026_;
  wire _0027_;
  wire _0028_;
  wire _0029_;
  wire _0030_;
  wire _0031_;
  wire _0032_;
  wire _0033_;
  wire _0034_;
  wire _0035_;
  wire _0036_;
  wire _0037_;
  wire _0038_;
  wire _0039_;
  wire _0040_;
  wire _0041_;
  wire _0042_;
  wire _0043_;
  wire _0044_;
  wire _0045_;
  wire _0046_;
  wire _0047_;
  wire _0048_;
  wire _0049_;
  wire _0050_;
  wire _0051_;
  wire _0052_;
  wire _0053_;
  wire _0054_;
  wire _0055_;
  wire _0056_;
  wire _0057_;
  wire _0058_;
  wire _0059_;
  wire _0060_;
  wire _0061_;
  wire _0062_;
  wire _0063_;
  wire _0064_;
  wire _0065_;
  wire _0066_;
  wire _0067_;
  wire _0068_;
  wire _0069_;
  wire _0070_;
  wire _0071_;
  wire _0072_;
  wire _0073_;
  wire _0074_;
  wire _0075_;
  wire _0076_;
  wire _0077_;
  wire _0078_;
  wire _0079_;
  wire _0080_;
  wire _0081_;
  wire _0082_;
  wire _0083_;
  wire _0084_;
  wire _0085_;
  wire _0086_;
  wire _0087_;
  wire _0088_;
  wire _0089_;
  wire _0090_;
  wire _0091_;
  wire _0092_;
  wire _0093_;
  wire _0094_;
  wire _0095_;
  wire _0096_;
  wire _0097_;
  wire _0098_;
  wire _0099_;
  wire _0100_;
  wire _0101_;
  wire _0102_;
  wire _0103_;
  wire _0104_;
  wire _0105_;
  wire _0106_;
  wire _0107_;
  wire _0108_;
  wire _0109_;
  wire _0110_;
  wire _0111_;
  wire _0112_;
  wire _0113_;
  wire _0114_;
  wire _0115_;
  wire _0116_;
  wire _0117_;
  wire _0118_;
  wire _0119_;
  wire _0120_;
  wire _0121_;
  wire _0122_;
  wire _0123_;
  wire _0124_;
  wire _0125_;
  wire _0126_;
  wire _0127_;
  wire _0128_;
  wire _0129_;
  wire _0130_;
  wire _0131_;
  wire _0132_;
  wire _0133_;
  wire _0134_;
  wire _0135_;
  wire _0136_;
  wire _0137_;
  wire _0138_;
  wire _0139_;
  wire _0140_;
  wire _0141_;
  wire _0142_;
  wire _0143_;
  wire _0144_;
  wire _0145_;
  wire _0146_;
  wire _0147_;
  wire _0148_;
  wire _0149_;
  wire _0150_;
  wire _0151_;
  wire _0152_;
  wire _0153_;
  wire _0154_;
  wire _0155_;
  wire _0156_;
  wire _0157_;
  wire _0158_;
  wire _0159_;
  wire _0160_;
  wire _0161_;
  wire _0162_;
  wire _0163_;
  wire _0164_;
  wire _0165_;
  wire _0166_;
  wire _0167_;
  wire _0168_;
  wire _0169_;
  wire _0170_;
  wire _0171_;
  wire _0172_;
  wire _0173_;
  wire _0174_;
  wire _0175_;
  wire _0176_;
  wire _0177_;
  wire _0178_;
  wire _0179_;
  wire _0180_;
  wire _0181_;
  wire _0182_;
  wire _0183_;
  wire _0184_;
  wire _0185_;
  wire _0186_;
  wire _0187_;
  wire _0188_;
  wire _0189_;
  wire _0190_;
  wire _0191_;
  wire _0192_;
  wire _0193_;
  wire _0194_;
  wire _0195_;
  wire _0196_;
  wire _0197_;
  wire _0198_;
  wire _0199_;
  wire _0200_;
  wire _0201_;
  wire _0202_;
  wire _0203_;
  wire _0204_;
  wire _0205_;
  wire _0206_;
  wire _0207_;
  wire _0208_;
  wire _0209_;
  wire _0210_;
  wire _0211_;
  wire _0212_;
  wire _0213_;
  wire _0214_;
  wire _0215_;
  wire _0216_;
  wire _0217_;
  wire _0218_;
  wire _0219_;
  wire _0220_;
  wire _0221_;
  wire _0222_;
  wire _0223_;
  wire _0224_;
  wire _0225_;
  wire _0226_;
  wire _0227_;
  wire _0228_;
  wire _0229_;
  wire _0230_;
  wire _0231_;
  wire _0232_;
  wire _0233_;
  wire _0234_;
  wire _0235_;
  wire _0236_;
  wire _0237_;
  wire _0238_;
  wire _0239_;
  wire _0240_;
  wire _0241_;
  wire _0242_;
  wire _0243_;
  wire _0244_;
  wire _0245_;
  wire _0246_;
  wire _0247_;
  wire _0248_;
  wire _0249_;
  wire _0250_;
  wire _0251_;
  wire _0252_;
  wire _0253_;
  wire _0254_;
  wire _0255_;
  wire _0256_;
  wire _0257_;
  wire _0258_;
  wire _0259_;
  wire _0260_;
  wire _0261_;
  wire _0262_;
  wire _0263_;
  wire _0264_;
  wire _0265_;
  wire _0266_;
  wire _0267_;
  wire _0268_;
  wire _0269_;
  wire _0270_;
  wire _0271_;
  wire _0272_;
  wire _0273_;
  wire _0274_;
  wire _0275_;
  wire _0276_;
  wire _0277_;
  wire _0278_;
  wire _0279_;
  wire _0280_;
  wire _0281_;
  wire _0282_;
  wire _0283_;
  wire _0284_;
  wire _0285_;
  wire _0286_;
  wire _0287_;
  wire _0288_;
  wire _0289_;
  wire _0290_;
  wire _0291_;
  wire _0292_;
  wire _0293_;
  wire _0294_;
  wire _0295_;
  wire _0296_;
  wire _0297_;
  wire _0298_;
  wire _0299_;
  wire _0300_;
  wire _0301_;
  wire _0302_;
  wire _0303_;
  wire _0304_;
  wire _0305_;
  wire _0306_;
  wire _0307_;
  wire _0308_;
  wire _0309_;
  wire _0310_;
  wire _0311_;
  wire _0312_;
  wire _0313_;
  wire _0314_;
  wire _0315_;
  wire _0316_;
  wire _0317_;
  wire _0318_;
  wire _0319_;
  wire _0320_;
  wire _0321_;
  wire _0322_;
  wire _0323_;
  wire _0324_;
  wire _0325_;
  wire _0326_;
  wire _0327_;
  wire _0328_;
  wire _0329_;
  wire _0330_;
  wire _0331_;
  wire _0332_;
  wire _0333_;
  wire _0334_;
  wire _0335_;
  wire _0336_;
  wire _0337_;
  wire _0338_;
  wire _0339_;
  wire _0340_;
  wire _0341_;
  wire _0342_;
  wire _0343_;
  wire _0344_;
  wire _0345_;
  wire _0346_;
  wire _0347_;
  wire _0348_;
  wire _0349_;
  wire _0350_;
  wire _0351_;
  wire _0352_;
  wire _0353_;
  wire _0354_;
  wire _0355_;
  wire _0356_;
  wire _0357_;
  wire _0358_;
  wire _0359_;
  wire _0360_;
  wire _0361_;
  wire _0362_;
  wire _0363_;
  wire _0364_;
  wire _0365_;
  wire _0366_;
  wire _0367_;
  wire _0368_;
  wire _0369_;
  wire _0370_;
  wire _0371_;
  wire _0372_;
  wire _0373_;
  wire _0374_;
  wire _0375_;
  wire _0376_;
  wire _0377_;
  wire _0378_;
  wire _0379_;
  wire _0380_;
  wire _0381_;
  wire _0382_;
  wire _0383_;
  wire _0384_;
  wire _0385_;
  wire _0386_;
  wire _0387_;
  wire _0388_;
  wire _0389_;
  wire _0390_;
  wire _0391_;
  wire _0392_;
  wire _0393_;
  wire _0394_;
  wire _0395_;
  wire _0396_;
  wire _0397_;
  wire _0398_;
  wire _0399_;
  wire _0400_;
  wire _0401_;
  wire _0402_;
  wire _0403_;
  wire _0404_;
  wire _0405_;
  wire _0406_;
  wire _0407_;
  wire _0408_;
  wire _0409_;
  wire _0410_;
  wire _0411_;
  wire _0412_;
  wire _0413_;
  wire _0414_;
  wire _0415_;
  wire _0416_;
  wire _0417_;
  wire _0418_;
  wire _0419_;
  wire _0420_;
  wire _0421_;
  wire _0422_;
  wire _0423_;
  wire _0424_;
  wire _0425_;
  wire _0426_;
  wire _0427_;
  wire _0428_;
  wire _0429_;
  wire _0430_;
  wire _0431_;
  wire _0432_;
  wire _0433_;
  wire _0434_;
  wire _0435_;
  wire _0436_;
  wire _0437_;
  wire _0438_;
  wire _0439_;
  wire _0440_;
  wire _0441_;
  wire _0442_;
  wire _0443_;
  wire _0444_;
  wire _0445_;
  wire _0446_;
  wire _0447_;
  wire _0448_;
  wire _0449_;
  wire _0450_;
  wire _0451_;
  wire _0452_;
  wire _0453_;
  wire _0454_;
  wire _0455_;
  wire _0456_;
  wire _0457_;
  wire _0458_;
  wire _0459_;
  wire _0460_;
  wire _0461_;
  wire _0462_;
  wire _0463_;
  wire _0464_;
  wire _0465_;
  wire _0466_;
  wire _0467_;
  wire _0468_;
  wire _0469_;
  wire _0470_;
  wire _0471_;
  wire _0472_;
  wire _0473_;
  wire _0474_;
  wire _0475_;
  wire _0476_;
  wire _0477_;
  wire _0478_;
  wire _0479_;
  wire _0480_;
  wire _0481_;
  wire _0482_;
  wire _0483_;
  wire _0484_;
  wire _0485_;
  wire _0486_;
  wire _0487_;
  wire _0488_;
  wire _0489_;
  wire _0490_;
  wire _0491_;
  wire _0492_;
  wire _0493_;
  wire _0494_;
  wire _0495_;
  wire _0496_;
  wire _0497_;
  wire _0498_;
  wire _0499_;
  wire _0500_;
  wire _0501_;
  wire _0502_;
  wire _0503_;
  wire _0504_;
  wire _0505_;
  wire _0506_;
  wire _0507_;
  wire _0508_;
  wire _0509_;
  wire _0510_;
  wire _0511_;
  wire _0512_;
  wire _0513_;
  wire _0514_;
  wire _0515_;
  wire _0516_;
  wire _0517_;
  wire _0518_;
  wire _0519_;
  wire _0520_;
  wire _0521_;
  wire _0522_;
  wire _0523_;
  wire _0524_;
  wire _0525_;
  wire _0526_;
  wire _0527_;
  wire _0528_;
  wire _0529_;
  wire _0530_;
  wire _0531_;
  wire _0532_;
  wire _0533_;
  wire _0534_;
  wire _0535_;
  wire _0536_;
  wire _0537_;
  wire _0538_;
  wire _0539_;
  wire _0540_;
  wire _0541_;
  wire _0542_;
  wire _0543_;
  wire _0544_;
  wire _0545_;
  wire _0546_;
  wire _0547_;
  wire _0548_;
  wire _0549_;
  wire _0550_;
  wire _0551_;
  wire _0552_;
  wire _0553_;
  wire _0554_;
  wire _0555_;
  wire _0556_;
  wire _0557_;
  wire _0558_;
  wire _0559_;
  wire _0560_;
  wire _0561_;
  wire _0562_;
  wire _0563_;
  wire _0564_;
  wire _0565_;
  wire _0566_;
  wire _0567_;
  wire _0568_;
  wire _0569_;
  wire _0570_;
  wire _0571_;
  wire _0572_;
  wire _0573_;
  wire _0574_;
  wire _0575_;
  wire _0576_;
  wire _0577_;
  wire _0578_;
  wire _0579_;
  wire _0580_;
  wire _0581_;
  wire _0582_;
  wire _0583_;
  wire _0584_;
  wire _0585_;
  wire _0586_;
  wire _0587_;
  wire _0588_;
  wire _0589_;
  wire _0590_;
  wire _0591_;
  wire _0592_;
  wire _0593_;
  wire _0594_;
  wire _0595_;
  wire _0596_;
  wire _0597_;
  wire _0598_;
  wire _0599_;
  wire _0600_;
  wire _0601_;
  wire _0602_;
  wire _0603_;
  wire _0604_;
  wire _0605_;
  wire _0606_;
  wire _0607_;
  wire _0608_;
  wire _0609_;
  wire _0610_;
  wire _0611_;
  wire _0612_;
  wire _0613_;
  wire _0614_;
  wire _0615_;
  wire _0616_;
  wire _0617_;
  wire _0618_;
  wire _0619_;
  wire _0620_;
  wire _0621_;
  wire _0622_;
  wire _0623_;
  wire _0624_;
  wire _0625_;
  wire _0626_;
  wire _0627_;
  wire _0628_;
  wire _0629_;
  wire _0630_;
  wire _0631_;
  wire _0632_;
  wire _0633_;
  wire _0634_;
  wire _0635_;
  wire _0636_;
  wire _0637_;
  wire _0638_;
  wire _0639_;
  wire _0640_;
  wire _0641_;
  wire _0642_;
  wire _0643_;
  wire _0644_;
  wire _0645_;
  wire _0646_;
  wire _0647_;
  wire _0648_;
  wire _0649_;
  wire _0650_;
  wire _0651_;
  wire _0652_;
  wire _0653_;
  wire _0654_;
  wire _0655_;
  wire _0656_;
  wire _0657_;
  wire _0658_;
  wire _0659_;
  wire _0660_;
  wire _0661_;
  wire _0662_;
  wire _0663_;
  wire _0664_;
  wire _0665_;
  wire _0666_;
  wire _0667_;
  wire _0668_;
  wire _0669_;
  wire _0670_;
  wire _0671_;
  wire _0672_;
  wire _0673_;
  wire _0674_;
  wire _0675_;
  wire _0676_;
  wire _0677_;
  wire _0678_;
  wire _0679_;
  wire _0680_;
  wire _0681_;
  wire _0682_;
  wire _0683_;
  wire _0684_;
  wire _0685_;
  wire _0686_;
  wire _0687_;
  wire _0688_;
  wire _0689_;
  wire _0690_;
  wire _0691_;
  wire _0692_;
  wire _0693_;
  wire _0694_;
  wire _0695_;
  wire _0696_;
  wire _0697_;
  wire _0698_;
  wire _0699_;
  wire _0700_;
  wire _0701_;
  wire _0702_;
  wire _0703_;
  wire _0704_;
  wire _0705_;
  wire _0706_;
  wire _0707_;
  wire _0708_;
  wire _0709_;
  wire _0710_;
  wire _0711_;
  wire _0712_;
  wire _0713_;
  wire _0714_;
  wire _0715_;
  wire _0716_;
  wire _0717_;
  wire _0718_;
  wire _0719_;
  wire _0720_;
  wire _0721_;
  wire _0722_;
  wire _0723_;
  wire _0724_;
  wire _0725_;
  wire _0726_;
  wire _0727_;
  wire _0728_;
  wire _0729_;
  wire _0730_;
  wire _0731_;
  wire _0732_;
  wire _0733_;
  wire _0734_;
  wire _0735_;
  wire _0736_;
  wire _0737_;
  wire _0738_;
  wire _0739_;
  wire _0740_;
  wire _0741_;
  wire _0742_;
  wire _0743_;
  wire _0744_;
  wire _0745_;
  wire _0746_;
  wire _0747_;
  wire _0748_;
  wire _0749_;
  wire _0750_;
  wire _0751_;
  wire _0752_;
  wire _0753_;
  wire _0754_;
  wire _0755_;
  wire _0756_;
  wire _0757_;
  wire _0758_;
  wire _0759_;
  wire _0760_;
  wire _0761_;
  wire _0762_;
  wire _0763_;
  wire _0764_;
  wire _0765_;
  wire _0766_;
  wire _0767_;
  wire _0768_;
  wire _0769_;
  wire _0770_;
  wire _0771_;
  wire _0772_;
  wire _0773_;
  wire _0774_;
  wire _0775_;
  wire _0776_;
  wire _0777_;
  wire _0778_;
  wire _0779_;
  wire _0780_;
  wire _0781_;
  wire _0782_;
  wire _0783_;
  wire _0784_;
  wire _0785_;
  wire _0786_;
  wire _0787_;
  wire _0788_;
  wire _0789_;
  wire _0790_;
  wire _0791_;
  wire _0792_;
  wire _0793_;
  wire _0794_;
  wire _0795_;
  wire _0796_;
  wire _0797_;
  wire _0798_;
  wire _0799_;
  wire _0800_;
  wire _0801_;
  wire _0802_;
  wire _0803_;
  wire _0804_;
  wire _0805_;
  wire _0806_;
  wire _0807_;
  wire _0808_;
  wire _0809_;
  wire _0810_;
  wire _0811_;
  wire _0812_;
  wire _0813_;
  wire _0814_;
  wire _0815_;
  wire _0816_;
  wire _0817_;
  wire _0818_;
  wire _0819_;
  wire _0820_;
  wire _0821_;
  wire _0822_;
  wire _0823_;
  wire _0824_;
  wire _0825_;
  wire _0826_;
  wire _0827_;
  wire _0828_;
  wire _0829_;
  wire _0830_;
  wire _0831_;
  wire _0832_;
  wire _0833_;
  wire _0834_;
  wire _0835_;
  wire _0836_;
  wire _0837_;
  wire _0838_;
  wire _0839_;
  wire _0840_;
  wire _0841_;
  wire _0842_;
  wire _0843_;
  wire _0844_;
  wire _0845_;
  wire _0846_;
  wire _0847_;
  wire _0848_;
  wire _0849_;
  wire _0850_;
  wire _0851_;
  wire _0852_;
  wire _0853_;
  wire _0854_;
  wire _0855_;
  wire _0856_;
  wire _0857_;
  wire _0858_;
  wire _0859_;
  wire _0860_;
  wire _0861_;
  wire _0862_;
  wire _0863_;
  wire _0864_;
  wire _0865_;
  wire _0866_;
  wire _0867_;
  wire _0868_;
  wire _0869_;
  wire _0870_;
  wire _0871_;
  wire _0872_;
  wire _0873_;
  wire _0874_;
  wire _0875_;
  wire _0876_;
  wire _0877_;
  wire _0878_;
  wire _0879_;
  wire _0880_;
  wire _0881_;
  wire _0882_;
  wire _0883_;
  wire _0884_;
  wire _0885_;
  wire _0886_;
  wire _0887_;
  wire _0888_;
  wire _0889_;
  wire _0890_;
  wire _0891_;
  wire _0892_;
  wire _0893_;
  wire _0894_;
  wire _0895_;
  wire _0896_;
  wire _0897_;
  wire _0898_;
  wire _0899_;
  wire _0900_;
  wire _0901_;
  wire _0902_;
  wire _0903_;
  wire _0904_;
  wire _0905_;
  wire _0906_;
  wire _0907_;
  wire _0908_;
  wire _0909_;
  wire [4:0] _0910_;
  wire [4:0] _0911_;
  wire [4:0] _0912_;
  wire [4:0] _0913_;
  wire _0914_;
  wire _0915_;
  wire _0916_;
  wire _0917_;
  wire _0918_;
  wire _0919_;
  wire _0920_;
  wire _0921_;
  wire _0922_;
  wire _0923_;
  wire _0924_;
  wire _0925_;
  wire _0926_;
  wire _0927_;
  wire _0928_;
  wire _0929_;
  wire _0930_;
  wire _0931_;
  wire _0932_;
  wire _0933_;
  wire _0934_;
  wire _0935_;
  wire _0936_;
  wire _0937_;
  wire _0938_;
  wire _0939_;
  wire _0940_;
  wire _0941_;
  wire _0942_;
  wire _0943_;
  wire _0944_;
  wire _0945_;
  wire _0946_;
  wire _0947_;
  wire _0948_;
  wire _0949_;
  wire _0950_;
  wire _0951_;
  wire _0952_;
  wire _0953_;
  wire _0954_;
  wire _0955_;
  wire _0956_;
  wire _0957_;
  wire _0958_;
  wire _0959_;
  wire _0960_;
  wire _0961_;
  wire _0962_;
  wire _0963_;
  wire _0964_;
  wire _0965_;
  wire _0966_;
  wire _0967_;
  wire _0968_;
  wire _0969_;
  wire _0970_;
  wire _0971_;
  wire _0972_;
  wire _0973_;
  wire _0974_;
  wire _0975_;
  wire _0976_;
  wire _0977_;
  wire _0978_;
  wire _0979_;
  wire _0980_;
  wire _0981_;
  wire _0982_;
  wire _0983_;
  wire _0984_;
  wire _0985_;
  wire _0986_;
  wire _0987_;
  wire _0988_;
  wire _0989_;
  wire _0990_;
  wire _0991_;
  wire _0992_;
  wire _0993_;
  wire _0994_;
  wire _0995_;
  wire _0996_;
  wire _0997_;
  wire _0998_;
  wire _0999_;
  wire _1000_;
  wire _1001_;
  wire _1002_;
  wire _1003_;
  wire _1004_;
  wire _1005_;
  wire _1006_;
  wire _1007_;
  wire _1008_;
  wire _1009_;
  wire _1010_;
  wire _1011_;
  wire _1012_;
  wire _1013_;
  wire _1014_;
  wire _1015_;
  wire _1016_;
  wire _1017_;
  wire _1018_;
  wire _1019_;
  wire _1020_;
  wire _1021_;
  wire _1022_;
  wire _1023_;
  wire _1024_;
  wire _1025_;
  wire _1026_;
  wire _1027_;
  wire _1028_;
  wire _1029_;
  wire _1030_;
  wire _1031_;
  wire _1032_;
  wire _1033_;
  wire _1034_;
  wire _1035_;
  wire _1036_;
  wire _1037_;
  wire _1038_;
  wire _1039_;
  wire _1040_;
  wire _1041_;
  wire _1042_;
  wire _1043_;
  wire _1044_;
  wire _1045_;
  wire _1046_;
  wire _1047_;
  wire _1048_;
  wire _1049_;
  wire _1050_;
  wire _1051_;
  wire _1052_;
  wire _1053_;
  wire _1054_;
  wire _1055_;
  wire _1056_;
  wire _1057_;
  wire _1058_;
  wire _1059_;
  wire _1060_;
  wire _1061_;
  wire _1062_;
  wire _1063_;
  wire _1064_;
  wire _1065_;
  wire _1066_;
  wire _1067_;
  wire _1068_;
  wire _1069_;
  wire _1070_;
  wire _1071_;
  wire _1072_;
  wire _1073_;
  wire _1074_;
  wire _1075_;
  wire _1076_;
  wire _1077_;
  wire _1078_;
  wire _1079_;
  wire _1080_;
  wire _1081_;
  wire _1082_;
  wire _1083_;
  wire _1084_;
  wire _1085_;
  wire _1086_;
  wire _1087_;
  wire _1088_;
  wire _1089_;
  wire _1090_;
  wire _1091_;
  wire _1092_;
  wire _1093_;
  wire _1094_;
  wire _1095_;
  wire _1096_;
  wire _1097_;
  wire _1098_;
  wire _1099_;
  wire _1100_;
  wire _1101_;
  wire _1102_;
  wire _1103_;
  wire _1104_;
  wire _1105_;
  wire _1106_;
  wire _1107_;
  wire _1108_;
  wire _1109_;
  wire _1110_;
  wire _1111_;
  wire _1112_;
  wire _1113_;
  wire _1114_;
  wire _1115_;
  wire _1116_;
  wire _1117_;
  wire _1118_;
  wire _1119_;
  wire _1120_;
  wire _1121_;
  wire _1122_;
  wire _1123_;
  wire _1124_;
  wire _1125_;
  wire _1126_;
  wire _1127_;
  wire _1128_;
  wire _1129_;
  wire _1130_;
  wire _1131_;
  wire _1132_;
  wire _1133_;
  wire _1134_;
  wire _1135_;
  wire _1136_;
  wire _1137_;
  wire _1138_;
  wire _1139_;
  wire _1140_;
  wire _1141_;
  wire _1142_;
  wire _1143_;
  wire _1144_;
  wire _1145_;
  wire _1146_;
  wire _1147_;
  wire _1148_;
  wire _1149_;
  wire _1150_;
  wire _1151_;
  wire _1152_;
  wire _1153_;
  wire _1154_;
  wire _1155_;
  wire _1156_;
  wire _1157_;
  wire _1158_;
  wire _1159_;
  wire _1160_;
  wire _1161_;
  wire _1162_;
  wire _1163_;
  wire _1164_;
  wire _1165_;
  wire _1166_;
  wire _1167_;
  wire _1168_;
  wire _1169_;
  wire _1170_;
  wire _1171_;
  wire _1172_;
  wire _1173_;
  wire _1174_;
  wire _1175_;
  wire _1176_;
  wire _1177_;
  wire _1178_;
  wire _1179_;
  wire _1180_;
  wire _1181_;
  wire _1182_;
  wire _1183_;
  wire _1184_;
  wire _1185_;
  wire _1186_;
  wire _1187_;
  wire _1188_;
  wire _1189_;
  wire _1190_;
  wire _1191_;
  wire _1192_;
  wire _1193_;
  wire _1194_;
  wire _1195_;
  wire _1196_;
  wire _1197_;
  wire _1198_;
  wire _1199_;
  wire _1200_;
  wire _1201_;
  wire _1202_;
  wire _1203_;
  wire _1204_;
  wire _1205_;
  wire _1206_;
  wire _1207_;
  wire _1208_;
  wire _1209_;
  wire _1210_;
  wire _1211_;
  wire _1212_;
  wire _1213_;
  wire _1214_;
  wire _1215_;
  wire _1216_;
  wire _1217_;
  wire _1218_;
  wire _1219_;
  wire _1220_;
  wire _1221_;
  wire _1222_;
  wire _1223_;
  wire _1224_;
  wire _1225_;
  wire _1226_;
  wire _1227_;
  wire _1228_;
  wire _1229_;
  wire _1230_;
  wire _1231_;
  wire _1232_;
  wire _1233_;
  wire _1234_;
  wire _1235_;
  wire _1236_;
  wire _1237_;
  wire _1238_;
  wire _1239_;
  wire _1240_;
  wire _1241_;
  wire _1242_;
  wire _1243_;
  wire _1244_;
  wire _1245_;
  wire _1246_;
  wire _1247_;
  wire _1248_;
  wire _1249_;
  wire _1250_;
  wire _1251_;
  wire _1252_;
  wire _1253_;
  wire _1254_;
  wire _1255_;
  wire _1256_;
  wire _1257_;
  wire _1258_;
  wire _1259_;
  wire _1260_;
  wire _1261_;
  wire _1262_;
  wire _1263_;
  wire _1264_;
  wire _1265_;
  wire _1266_;
  wire _1267_;
  wire _1268_;
  wire _1269_;
  wire _1270_;
  wire _1271_;
  wire _1272_;
  wire _1273_;
  wire _1274_;
  wire _1275_;
  wire _1276_;
  wire _1277_;
  wire _1278_;
  wire _1279_;
  wire [15:0] baud_cnt;
  wire [15:0] baud_div;
  wire baud_tick;
  wire dlab;
  wire [7:0] dll_r;
  wire [7:0] dlm_r;
  wire [3:0] ier_r;
  wire [7:0] lcr_r;
  wire [6:0] lsr;
  wire lsr_oe_r;
  wire [4:0] mcr_r;
  wire [7:0] msr;
  wire [2:0] rx_bit_idx;
  wire [7:0] rx_byte_in;
  wire rx_push;
  wire [7:0] rx_shift;
  wire [3:0] rx_state;
  wire [3:0] rx_sub;
  wire [7:0] \rxf_mem[0] ;
  wire [7:0] \rxf_mem[10] ;
  wire [7:0] \rxf_mem[11] ;
  wire [7:0] \rxf_mem[12] ;
  wire [7:0] \rxf_mem[13] ;
  wire [7:0] \rxf_mem[14] ;
  wire [7:0] \rxf_mem[15] ;
  wire [7:0] \rxf_mem[1] ;
  wire [7:0] \rxf_mem[2] ;
  wire [7:0] \rxf_mem[3] ;
  wire [7:0] \rxf_mem[4] ;
  wire [7:0] \rxf_mem[5] ;
  wire [7:0] \rxf_mem[6] ;
  wire [7:0] \rxf_mem[7] ;
  wire [7:0] \rxf_mem[8] ;
  wire [7:0] \rxf_mem[9] ;
  wire [4:0] rxf_rptr;
  wire rxf_wen;
  wire [4:0] rxf_wptr;
  wire [7:0] scr_r;
  wire sin_s1;
  wire sin_s2;
  wire [2:0] tx_bit_idx;
  wire [7:0] tx_shift;
  wire [3:0] tx_state;
  wire [3:0] tx_sub;
  wire txf_empty;
  wire [7:0] \txf_mem[0] ;
  wire [7:0] \txf_mem[10] ;
  wire [7:0] \txf_mem[11] ;
  wire [7:0] \txf_mem[12] ;
  wire [7:0] \txf_mem[13] ;
  wire [7:0] \txf_mem[14] ;
  wire [7:0] \txf_mem[15] ;
  wire [7:0] \txf_mem[1] ;
  wire [7:0] \txf_mem[2] ;
  wire [7:0] \txf_mem[3] ;
  wire [7:0] \txf_mem[4] ;
  wire [7:0] \txf_mem[5] ;
  wire [7:0] \txf_mem[6] ;
  wire [7:0] \txf_mem[7] ;
  wire [7:0] \txf_mem[8] ;
  wire [7:0] \txf_mem[9] ;
  wire [4:0] txf_rptr;
  wire [4:0] txf_wptr;
  NAND4_X1 _1280_ (
    .A1(_0667_),
    .A2(_0668_),
    .A3(_0669_),
    .A4(_0670_),
    .ZN(_0671_)
  );
  AOI22_X1 _1281_ (
    .A1(\txf_mem[15] [7]),
    .A2(_0555_),
    .B1(_0557_),
    .B2(\txf_mem[10] [7]),
    .ZN(_0672_)
  );
  AOI22_X1 _1282_ (
    .A1(\txf_mem[6] [7]),
    .A2(_0558_),
    .B1(_0561_),
    .B2(\txf_mem[14] [7]),
    .ZN(_0673_)
  );
  AOI22_X1 _1283_ (
    .A1(\txf_mem[13] [7]),
    .A2(_0547_),
    .B1(_0553_),
    .B2(\txf_mem[5] [7]),
    .ZN(_0674_)
  );
  AOI22_X1 _1284_ (
    .A1(\txf_mem[8] [7]),
    .A2(_0541_),
    .B1(_0543_),
    .B2(\txf_mem[11] [7]),
    .ZN(_0675_)
  );
  NAND4_X1 _1285_ (
    .A1(_0672_),
    .A2(_0673_),
    .A3(_0674_),
    .A4(_0675_),
    .ZN(_0676_)
  );
  NOR3_X1 _1286_ (
    .A1(_0436_),
    .A2(_0671_),
    .A3(_0676_),
    .ZN(_0677_)
  );
  AOI21_X1 _1287_ (
    .A(_0677_),
    .B1(_0436_),
    .B2(_0747_),
    .ZN(_0209_)
  );
  MUX2_X1 _1288_ (
    .A(rx_shift[2]),
    .B(\rxf_mem[15] [2]),
    .S(_0657_),
    .Z(_0210_)
  );
  MUX2_X1 _1289_ (
    .A(rx_shift[1]),
    .B(\rxf_mem[15] [1]),
    .S(_0657_),
    .Z(_0211_)
  );
  MUX2_X1 _1290_ (
    .A(rx_shift[0]),
    .B(\rxf_mem[15] [0]),
    .S(_0657_),
    .Z(_0212_)
  );
  MUX2_X1 _1291_ (
    .A(rx_shift[5]),
    .B(\rxf_mem[2] [5]),
    .S(_0665_),
    .Z(_0213_)
  );
  MUX2_X1 _1292_ (
    .A(dll_r[6]),
    .B(PWDATA[6]),
    .S(_0654_),
    .Z(_0214_)
  );
  MUX2_X1 _1293_ (
    .A(dll_r[5]),
    .B(PWDATA[5]),
    .S(_0654_),
    .Z(_0215_)
  );
  MUX2_X1 _1294_ (
    .A(dll_r[4]),
    .B(PWDATA[4]),
    .S(_0654_),
    .Z(_0216_)
  );
  MUX2_X1 _1295_ (
    .A(dll_r[3]),
    .B(PWDATA[3]),
    .S(_0654_),
    .Z(_0217_)
  );
  MUX2_X1 _1296_ (
    .A(rx_shift[7]),
    .B(\rxf_mem[6] [7]),
    .S(_0538_),
    .Z(_0218_)
  );
  MUX2_X1 _1297_ (
    .A(dll_r[2]),
    .B(PWDATA[2]),
    .S(_0654_),
    .Z(_0219_)
  );
  OAI21_X1 _1298_ (
    .A(_0728_),
    .B1(_0013_),
    .B2(_0472_),
    .ZN(_0678_)
  );
  OAI21_X1 _1299_ (
    .A(_0678_),
    .B1(_0795_),
    .B2(_0761_),
    .ZN(_0679_)
  );
  INV_X1 _1300_ (
    .A(_0679_),
    .ZN(_0220_)
  );
  MUX2_X1 _1301_ (
    .A(dll_r[1]),
    .B(PWDATA[1]),
    .S(_0654_),
    .Z(_0221_)
  );
  MUX2_X1 _1302_ (
    .A(dll_r[0]),
    .B(PWDATA[0]),
    .S(_0654_),
    .Z(_0222_)
  );
  MUX2_X1 _1303_ (
    .A(rx_shift[4]),
    .B(\rxf_mem[2] [4]),
    .S(_0665_),
    .Z(_0223_)
  );
  NOR2_X1 _1304_ (
    .A1(_0762_),
    .A2(_0535_),
    .ZN(_0680_)
  );
  XOR2_X1 _1305_ (
    .A(rxf_rptr[4]),
    .B(_0680_),
    .Z(_0224_)
  );
  MUX2_X1 _1306_ (
    .A(\rxf_mem[9] [7]),
    .B(rx_shift[7]),
    .S(_0533_),
    .Z(_0225_)
  );
  MUX2_X1 _1307_ (
    .A(\txf_mem[13] [7]),
    .B(PWDATA[7]),
    .S(_0532_),
    .Z(_0226_)
  );
  XNOR2_X1 _1308_ (
    .A(rxf_wptr[4]),
    .B(_0656_),
    .ZN(_0227_)
  );
  NAND3_X1 _1309_ (
    .A1(rx_bit_idx[0]),
    .A2(rx_bit_idx[1]),
    .A3(_0518_),
    .ZN(_0681_)
  );
  MUX2_X1 _1310_ (
    .A(sin_s2),
    .B(rx_shift[7]),
    .S(_0681_),
    .Z(_0228_)
  );
  AOI21_X1 _1311_ (
    .A(_0509_),
    .B1(_0508_),
    .B2(_0745_),
    .ZN(_0229_)
  );
  MUX2_X1 _1312_ (
    .A(rx_shift[6]),
    .B(\rxf_mem[7] [6]),
    .S(_0653_),
    .Z(_0230_)
  );
  MUX2_X1 _1313_ (
    .A(rx_shift[5]),
    .B(\rxf_mem[7] [5]),
    .S(_0653_),
    .Z(_0231_)
  );
  MUX2_X1 _1314_ (
    .A(rx_shift[4]),
    .B(\rxf_mem[7] [4]),
    .S(_0653_),
    .Z(_0232_)
  );
  NAND4_X1 _1315_ (
    .A1(tx_sub[0]),
    .A2(tx_sub[1]),
    .A3(tx_sub[2]),
    .A4(_0502_),
    .ZN(_0682_)
  );
  OR2_X1 _1316_ (
    .A1(_0438_),
    .A2(_0498_),
    .ZN(_0683_)
  );
  AOI22_X1 _1317_ (
    .A1(_0759_),
    .A2(_0682_),
    .B1(_0683_),
    .B2(_0502_),
    .ZN(_0233_)
  );
  MUX2_X1 _1318_ (
    .A(rx_shift[3]),
    .B(\rxf_mem[7] [3]),
    .S(_0653_),
    .Z(_0234_)
  );
  MUX2_X1 _1319_ (
    .A(rx_shift[2]),
    .B(\rxf_mem[7] [2]),
    .S(_0653_),
    .Z(_0235_)
  );
  MUX2_X1 _1320_ (
    .A(rx_shift[1]),
    .B(\rxf_mem[7] [1]),
    .S(_0653_),
    .Z(_0236_)
  );
  MUX2_X1 _1321_ (
    .A(\rxf_mem[0] [7]),
    .B(rx_shift[7]),
    .S(_0496_),
    .Z(_0237_)
  );
  MUX2_X1 _1322_ (
    .A(rx_shift[0]),
    .B(\rxf_mem[7] [0]),
    .S(_0653_),
    .Z(_0238_)
  );
  MUX2_X1 _1323_ (
    .A(\rxf_mem[4] [7]),
    .B(rx_shift[7]),
    .S(_0495_),
    .Z(_0239_)
  );
  MUX2_X1 _1324_ (
    .A(PWDATA[7]),
    .B(\txf_mem[3] [7]),
    .S(_0490_),
    .Z(_0240_)
  );
  MUX2_X1 _1325_ (
    .A(rx_shift[3]),
    .B(\rxf_mem[2] [3]),
    .S(_0665_),
    .Z(_0241_)
  );
  MUX2_X1 _1326_ (
    .A(PWDATA[6]),
    .B(\txf_mem[15] [6]),
    .S(_0652_),
    .Z(_0242_)
  );
  MUX2_X1 _1327_ (
    .A(PWDATA[5]),
    .B(\txf_mem[15] [5]),
    .S(_0652_),
    .Z(_0243_)
  );
  MUX2_X1 _1328_ (
    .A(PWDATA[4]),
    .B(\txf_mem[15] [4]),
    .S(_0652_),
    .Z(_0244_)
  );
  MUX2_X1 _1329_ (
    .A(PWDATA[3]),
    .B(\txf_mem[15] [3]),
    .S(_0652_),
    .Z(_0245_)
  );
  MUX2_X1 _1330_ (
    .A(PWDATA[2]),
    .B(\txf_mem[15] [2]),
    .S(_0652_),
    .Z(_0246_)
  );
  MUX2_X1 _1331_ (
    .A(PWDATA[1]),
    .B(\txf_mem[15] [1]),
    .S(_0652_),
    .Z(_0247_)
  );
  MUX2_X1 _1332_ (
    .A(PWDATA[0]),
    .B(\txf_mem[15] [0]),
    .S(_0652_),
    .Z(_0248_)
  );
  MUX2_X1 _1333_ (
    .A(rx_shift[2]),
    .B(\rxf_mem[2] [2]),
    .S(_0665_),
    .Z(_0249_)
  );
  MUX2_X1 _1334_ (
    .A(dlm_r[6]),
    .B(PWDATA[6]),
    .S(_0651_),
    .Z(_0250_)
  );
  MUX2_X1 _1335_ (
    .A(dlm_r[5]),
    .B(PWDATA[5]),
    .S(_0651_),
    .Z(_0251_)
  );
  MUX2_X1 _1336_ (
    .A(dlm_r[4]),
    .B(PWDATA[4]),
    .S(_0651_),
    .Z(_0252_)
  );
  MUX2_X1 _1337_ (
    .A(dlm_r[3]),
    .B(PWDATA[3]),
    .S(_0651_),
    .Z(_0253_)
  );
  MUX2_X1 _1338_ (
    .A(dlm_r[2]),
    .B(PWDATA[2]),
    .S(_0651_),
    .Z(_0254_)
  );
  MUX2_X1 _1339_ (
    .A(dlm_r[1]),
    .B(PWDATA[1]),
    .S(_0651_),
    .Z(_0255_)
  );
  MUX2_X1 _1340_ (
    .A(dlm_r[0]),
    .B(PWDATA[0]),
    .S(_0651_),
    .Z(_0256_)
  );
  MUX2_X1 _1341_ (
    .A(rx_shift[1]),
    .B(\rxf_mem[2] [1]),
    .S(_0665_),
    .Z(_0257_)
  );
  MUX2_X1 _1342_ (
    .A(\txf_mem[10] [6]),
    .B(PWDATA[6]),
    .S(_0641_),
    .Z(_0258_)
  );
  MUX2_X1 _1343_ (
    .A(\txf_mem[10] [5]),
    .B(PWDATA[5]),
    .S(_0641_),
    .Z(_0259_)
  );
  MUX2_X1 _1344_ (
    .A(\txf_mem[10] [4]),
    .B(PWDATA[4]),
    .S(_0641_),
    .Z(_0260_)
  );
  MUX2_X1 _1345_ (
    .A(\txf_mem[10] [3]),
    .B(PWDATA[3]),
    .S(_0641_),
    .Z(_0261_)
  );
  MUX2_X1 _1346_ (
    .A(\txf_mem[10] [2]),
    .B(PWDATA[2]),
    .S(_0641_),
    .Z(_0262_)
  );
  MUX2_X1 _1347_ (
    .A(\txf_mem[10] [1]),
    .B(PWDATA[1]),
    .S(_0641_),
    .Z(_0263_)
  );
  MUX2_X1 _1348_ (
    .A(\txf_mem[10] [0]),
    .B(PWDATA[0]),
    .S(_0641_),
    .Z(_0264_)
  );
  MUX2_X1 _1349_ (
    .A(rx_shift[0]),
    .B(\rxf_mem[2] [0]),
    .S(_0665_),
    .Z(_0265_)
  );
  MUX2_X1 _1350_ (
    .A(\txf_mem[5] [6]),
    .B(PWDATA[6]),
    .S(_0635_),
    .Z(_0266_)
  );
  MUX2_X1 _1351_ (
    .A(\txf_mem[5] [5]),
    .B(PWDATA[5]),
    .S(_0635_),
    .Z(_0267_)
  );
  MUX2_X1 _1352_ (
    .A(\txf_mem[5] [4]),
    .B(PWDATA[4]),
    .S(_0635_),
    .Z(_0268_)
  );
  MUX2_X1 _1353_ (
    .A(\txf_mem[5] [3]),
    .B(PWDATA[3]),
    .S(_0635_),
    .Z(_0269_)
  );
  MUX2_X1 _1354_ (
    .A(\txf_mem[5] [2]),
    .B(PWDATA[2]),
    .S(_0635_),
    .Z(_0270_)
  );
  MUX2_X1 _1355_ (
    .A(\txf_mem[5] [1]),
    .B(PWDATA[1]),
    .S(_0635_),
    .Z(_0271_)
  );
  MUX2_X1 _1356_ (
    .A(\txf_mem[5] [0]),
    .B(PWDATA[0]),
    .S(_0635_),
    .Z(_0272_)
  );
  NOR3_X1 _1357_ (
    .A1(txf_wptr[0]),
    .A2(txf_wptr[1]),
    .A3(_0489_),
    .ZN(_0684_)
  );
  MUX2_X1 _1358_ (
    .A(\txf_mem[0] [6]),
    .B(PWDATA[6]),
    .S(_0684_),
    .Z(_0273_)
  );
  MUX2_X1 _1359_ (
    .A(\rxf_mem[8] [6]),
    .B(rx_shift[6]),
    .S(_0634_),
    .Z(_0274_)
  );
  MUX2_X1 _1360_ (
    .A(\rxf_mem[8] [5]),
    .B(rx_shift[5]),
    .S(_0634_),
    .Z(_0275_)
  );
  MUX2_X1 _1361_ (
    .A(\rxf_mem[8] [4]),
    .B(rx_shift[4]),
    .S(_0634_),
    .Z(_0276_)
  );
  MUX2_X1 _1362_ (
    .A(\rxf_mem[8] [3]),
    .B(rx_shift[3]),
    .S(_0634_),
    .Z(_0277_)
  );
  MUX2_X1 _1363_ (
    .A(\rxf_mem[8] [2]),
    .B(rx_shift[2]),
    .S(_0634_),
    .Z(_0278_)
  );
  MUX2_X1 _1364_ (
    .A(\rxf_mem[8] [1]),
    .B(rx_shift[1]),
    .S(_0634_),
    .Z(_0279_)
  );
  MUX2_X1 _1365_ (
    .A(\rxf_mem[8] [0]),
    .B(rx_shift[0]),
    .S(_0634_),
    .Z(_0280_)
  );
  MUX2_X1 _1366_ (
    .A(\txf_mem[0] [5]),
    .B(PWDATA[5]),
    .S(_0684_),
    .Z(_0281_)
  );
  MUX2_X1 _1367_ (
    .A(\txf_mem[6] [6]),
    .B(PWDATA[6]),
    .S(_0633_),
    .Z(_0282_)
  );
  MUX2_X1 _1368_ (
    .A(\txf_mem[6] [5]),
    .B(PWDATA[5]),
    .S(_0633_),
    .Z(_0283_)
  );
  MUX2_X1 _1369_ (
    .A(\txf_mem[6] [4]),
    .B(PWDATA[4]),
    .S(_0633_),
    .Z(_0284_)
  );
  MUX2_X1 _1370_ (
    .A(\txf_mem[6] [3]),
    .B(PWDATA[3]),
    .S(_0633_),
    .Z(_0285_)
  );
  MUX2_X1 _1371_ (
    .A(\txf_mem[6] [2]),
    .B(PWDATA[2]),
    .S(_0633_),
    .Z(_0286_)
  );
  MUX2_X1 _1372_ (
    .A(\txf_mem[6] [1]),
    .B(PWDATA[1]),
    .S(_0633_),
    .Z(_0287_)
  );
  MUX2_X1 _1373_ (
    .A(\txf_mem[6] [0]),
    .B(PWDATA[0]),
    .S(_0633_),
    .Z(_0288_)
  );
  XNOR2_X1 _1374_ (
    .A(txf_wptr[4]),
    .B(_0484_),
    .ZN(_0289_)
  );
  MUX2_X1 _1375_ (
    .A(\txf_mem[0] [4]),
    .B(PWDATA[4]),
    .S(_0684_),
    .Z(_0290_)
  );
  MUX2_X1 _1376_ (
    .A(\txf_mem[9] [6]),
    .B(PWDATA[6]),
    .S(_0632_),
    .Z(_0291_)
  );
  MUX2_X1 _1377_ (
    .A(\txf_mem[11] [7]),
    .B(PWDATA[7]),
    .S(_0482_),
    .Z(_0292_)
  );
  MUX2_X1 _1378_ (
    .A(\txf_mem[9] [5]),
    .B(PWDATA[5]),
    .S(_0632_),
    .Z(_0293_)
  );
  MUX2_X1 _1379_ (
    .A(\txf_mem[9] [4]),
    .B(PWDATA[4]),
    .S(_0632_),
    .Z(_0294_)
  );
  MUX2_X1 _1380_ (
    .A(\txf_mem[7] [7]),
    .B(PWDATA[7]),
    .S(_0481_),
    .Z(_0295_)
  );
  MUX2_X1 _1381_ (
    .A(\txf_mem[9] [3]),
    .B(PWDATA[3]),
    .S(_0632_),
    .Z(_0296_)
  );
  MUX2_X1 _1382_ (
    .A(\rxf_mem[1] [7]),
    .B(rx_shift[7]),
    .S(_0476_),
    .Z(_0297_)
  );
  MUX2_X1 _1383_ (
    .A(\txf_mem[9] [2]),
    .B(PWDATA[2]),
    .S(_0632_),
    .Z(_0298_)
  );
  MUX2_X1 _1384_ (
    .A(\txf_mem[9] [1]),
    .B(PWDATA[1]),
    .S(_0632_),
    .Z(_0299_)
  );
  MUX2_X1 _1385_ (
    .A(\txf_mem[9] [0]),
    .B(PWDATA[0]),
    .S(_0632_),
    .Z(_0300_)
  );
  MUX2_X1 _1386_ (
    .A(\txf_mem[0] [3]),
    .B(PWDATA[3]),
    .S(_0684_),
    .Z(_0301_)
  );
  NOR2_X1 _1387_ (
    .A1(tx_bit_idx[0]),
    .A2(tx_shift[4]),
    .ZN(_0685_)
  );
  AOI211_X1 _1388_ (
    .A(tx_bit_idx[1]),
    .B(_0685_),
    .C1(_0746_),
    .C2(tx_bit_idx[0]),
    .ZN(_0686_)
  );
  NOR3_X1 _1389_ (
    .A1(_0743_),
    .A2(_0744_),
    .A3(_0747_),
    .ZN(_0687_)
  );
  NOR2_X1 _1390_ (
    .A1(tx_bit_idx[0]),
    .A2(_0744_),
    .ZN(_0688_)
  );
  AOI211_X1 _1391_ (
    .A(_0686_),
    .B(_0687_),
    .C1(_0688_),
    .C2(tx_shift[6]),
    .ZN(_0689_)
  );
  AOI21_X1 _1392_ (
    .A(tx_bit_idx[1]),
    .B1(tx_bit_idx[0]),
    .B2(_0742_),
    .ZN(_0690_)
  );
  OAI21_X1 _1393_ (
    .A(_0690_),
    .B1(tx_bit_idx[0]),
    .B2(tx_shift[0]),
    .ZN(_0691_)
  );
  AND3_X1 _1394_ (
    .A1(tx_bit_idx[0]),
    .A2(tx_bit_idx[1]),
    .A3(tx_shift[3]),
    .ZN(_0692_)
  );
  AOI211_X1 _1395_ (
    .A(tx_bit_idx[2]),
    .B(_0692_),
    .C1(_0688_),
    .C2(tx_shift[2]),
    .ZN(_0693_)
  );
  AOI221_X1 _1396_ (
    .A(_0748_),
    .B1(_0691_),
    .B2(_0693_),
    .C1(_0689_),
    .C2(tx_bit_idx[2]),
    .ZN(_0694_)
  );
  NOR3_X1 _1397_ (
    .A1(tx_state[3]),
    .A2(_0500_),
    .A3(_0694_),
    .ZN(_0695_)
  );
  AOI21_X1 _1398_ (
    .A(_0695_),
    .B1(_0760_),
    .B2(_0758_),
    .ZN(_0302_)
  );
  MUX2_X1 _1399_ (
    .A(\txf_mem[12] [7]),
    .B(PWDATA[7]),
    .S(_0470_),
    .Z(_0303_)
  );
  MUX2_X1 _1400_ (
    .A(scr_r[6]),
    .B(PWDATA[6]),
    .S(_0631_),
    .Z(_0304_)
  );
  NOR2_X1 _1401_ (
    .A1(_0475_),
    .A2(_0492_),
    .ZN(_0696_)
  );
  MUX2_X1 _1402_ (
    .A(\rxf_mem[5] [7]),
    .B(rx_shift[7]),
    .S(_0696_),
    .Z(_0305_)
  );
  MUX2_X1 _1403_ (
    .A(scr_r[5]),
    .B(PWDATA[5]),
    .S(_0631_),
    .Z(_0306_)
  );
  NOR3_X1 _1404_ (
    .A1(_0436_),
    .A2(_0542_),
    .A3(_0545_),
    .ZN(_0697_)
  );
  XOR2_X1 _1405_ (
    .A(txf_rptr[4]),
    .B(_0697_),
    .Z(_0307_)
  );
  MUX2_X1 _1406_ (
    .A(scr_r[4]),
    .B(PWDATA[4]),
    .S(_0631_),
    .Z(_0308_)
  );
  MUX2_X1 _1407_ (
    .A(scr_r[3]),
    .B(PWDATA[3]),
    .S(_0631_),
    .Z(_0309_)
  );
  MUX2_X1 _1408_ (
    .A(scr_r[2]),
    .B(PWDATA[2]),
    .S(_0631_),
    .Z(_0310_)
  );
  NOR2_X1 _1409_ (
    .A1(_0469_),
    .A2(_0487_),
    .ZN(_0698_)
  );
  MUX2_X1 _1410_ (
    .A(\txf_mem[14] [7]),
    .B(PWDATA[7]),
    .S(_0698_),
    .Z(_0311_)
  );
  MUX2_X1 _1411_ (
    .A(scr_r[1]),
    .B(PWDATA[1]),
    .S(_0631_),
    .Z(_0312_)
  );
  MUX2_X1 _1412_ (
    .A(scr_r[0]),
    .B(PWDATA[0]),
    .S(_0631_),
    .Z(_0313_)
  );
  MUX2_X1 _1413_ (
    .A(lcr_r[6]),
    .B(PWDATA[6]),
    .S(_0622_),
    .Z(_0314_)
  );
  NAND3_X1 _1414_ (
    .A1(rxf_wptr[2]),
    .A2(rxf_wptr[3]),
    .A3(_0529_),
    .ZN(_0699_)
  );
  MUX2_X1 _1415_ (
    .A(rx_shift[7]),
    .B(\rxf_mem[14] [7]),
    .S(_0699_),
    .Z(_0315_)
  );
  MUX2_X1 _1416_ (
    .A(\txf_mem[0] [7]),
    .B(PWDATA[7]),
    .S(_0684_),
    .Z(_0316_)
  );
  MUX2_X1 _1417_ (
    .A(lcr_r[5]),
    .B(PWDATA[5]),
    .S(_0622_),
    .Z(_0317_)
  );
  MUX2_X1 _1418_ (
    .A(lcr_r[4]),
    .B(PWDATA[4]),
    .S(_0622_),
    .Z(_0318_)
  );
  MUX2_X1 _1419_ (
    .A(lcr_r[3]),
    .B(PWDATA[3]),
    .S(_0622_),
    .Z(_0319_)
  );
  MUX2_X1 _1420_ (
    .A(rx_shift[7]),
    .B(\rxf_mem[2] [7]),
    .S(_0665_),
    .Z(_0320_)
  );
  MUX2_X1 _1421_ (
    .A(lcr_r[2]),
    .B(PWDATA[2]),
    .S(_0622_),
    .Z(_0321_)
  );
  MUX2_X1 _1422_ (
    .A(lcr_r[1]),
    .B(PWDATA[1]),
    .S(_0622_),
    .Z(_0322_)
  );
  MUX2_X1 _1423_ (
    .A(lcr_r[0]),
    .B(PWDATA[0]),
    .S(_0622_),
    .Z(_0323_)
  );
  MUX2_X1 _1424_ (
    .A(PWDATA[3]),
    .B(mcr_r[3]),
    .S(_0640_),
    .Z(_0324_)
  );
  MUX2_X1 _1425_ (
    .A(PWDATA[2]),
    .B(mcr_r[2]),
    .S(_0640_),
    .Z(_0325_)
  );
  MUX2_X1 _1426_ (
    .A(PWDATA[1]),
    .B(mcr_r[1]),
    .S(_0640_),
    .Z(_0326_)
  );
  MUX2_X1 _1427_ (
    .A(\txf_mem[2] [7]),
    .B(PWDATA[7]),
    .S(_0637_),
    .Z(_0327_)
  );
  MUX2_X1 _1428_ (
    .A(PWDATA[0]),
    .B(mcr_r[0]),
    .S(_0640_),
    .Z(_0328_)
  );
  MUX2_X1 _1429_ (
    .A(\txf_mem[8] [7]),
    .B(PWDATA[7]),
    .S(_0630_),
    .Z(_0329_)
  );
  MUX2_X1 _1430_ (
    .A(PWDATA[2]),
    .B(ier_r[2]),
    .S(_0664_),
    .Z(_0330_)
  );
  MUX2_X1 _1431_ (
    .A(PWDATA[1]),
    .B(ier_r[1]),
    .S(_0664_),
    .Z(_0331_)
  );
  MUX2_X1 _1432_ (
    .A(PWDATA[0]),
    .B(ier_r[0]),
    .S(_0664_),
    .Z(_0332_)
  );
  MUX2_X1 _1433_ (
    .A(\txf_mem[0] [2]),
    .B(PWDATA[2]),
    .S(_0684_),
    .Z(_0333_)
  );
  MUX2_X1 _1434_ (
    .A(\txf_mem[0] [1]),
    .B(PWDATA[1]),
    .S(_0684_),
    .Z(_0334_)
  );
  MUX2_X1 _1435_ (
    .A(\txf_mem[0] [0]),
    .B(PWDATA[0]),
    .S(_0684_),
    .Z(_0335_)
  );
  MUX2_X1 _1436_ (
    .A(rx_shift[6]),
    .B(\rxf_mem[14] [6]),
    .S(_0699_),
    .Z(_0336_)
  );
  MUX2_X1 _1437_ (
    .A(rx_shift[5]),
    .B(\rxf_mem[14] [5]),
    .S(_0699_),
    .Z(_0337_)
  );
  MUX2_X1 _1438_ (
    .A(rx_shift[4]),
    .B(\rxf_mem[14] [4]),
    .S(_0699_),
    .Z(_0338_)
  );
  MUX2_X1 _1439_ (
    .A(rx_shift[3]),
    .B(\rxf_mem[14] [3]),
    .S(_0699_),
    .Z(_0339_)
  );
  MUX2_X1 _1440_ (
    .A(rx_shift[2]),
    .B(\rxf_mem[14] [2]),
    .S(_0699_),
    .Z(_0340_)
  );
  MUX2_X1 _1441_ (
    .A(rx_shift[1]),
    .B(\rxf_mem[14] [1]),
    .S(_0699_),
    .Z(_0341_)
  );
  MUX2_X1 _1442_ (
    .A(rx_shift[0]),
    .B(\rxf_mem[14] [0]),
    .S(_0699_),
    .Z(_0342_)
  );
  MUX2_X1 _1443_ (
    .A(\txf_mem[14] [6]),
    .B(PWDATA[6]),
    .S(_0698_),
    .Z(_0343_)
  );
  MUX2_X1 _1444_ (
    .A(rx_shift[7]),
    .B(\rxf_mem[10] [7]),
    .S(_0530_),
    .Z(_0344_)
  );
  MUX2_X1 _1445_ (
    .A(\txf_mem[14] [5]),
    .B(PWDATA[5]),
    .S(_0698_),
    .Z(_0345_)
  );
  MUX2_X1 _1446_ (
    .A(\txf_mem[14] [4]),
    .B(PWDATA[4]),
    .S(_0698_),
    .Z(_0346_)
  );
  MUX2_X1 _1447_ (
    .A(\txf_mem[14] [3]),
    .B(PWDATA[3]),
    .S(_0698_),
    .Z(_0347_)
  );
  MUX2_X1 _1448_ (
    .A(\txf_mem[14] [2]),
    .B(PWDATA[2]),
    .S(_0698_),
    .Z(_0348_)
  );
  MUX2_X1 _1449_ (
    .A(\txf_mem[14] [1]),
    .B(PWDATA[1]),
    .S(_0698_),
    .Z(_0349_)
  );
  MUX2_X1 _1450_ (
    .A(\txf_mem[14] [0]),
    .B(PWDATA[0]),
    .S(_0698_),
    .Z(_0350_)
  );
  NOR2_X1 _1451_ (
    .A1(_0436_),
    .A2(_0542_),
    .ZN(_0700_)
  );
  INV_X1 _1452_ (
    .A(_0700_),
    .ZN(_0701_)
  );
  NOR2_X1 _1453_ (
    .A1(_0708_),
    .A2(_0701_),
    .ZN(_0702_)
  );
  OAI22_X1 _1454_ (
    .A1(_0551_),
    .A2(_0701_),
    .B1(_0702_),
    .B2(_0707_),
    .ZN(_0351_)
  );
  XNOR2_X1 _1455_ (
    .A(_0708_),
    .B(_0700_),
    .ZN(_0352_)
  );
  AOI21_X1 _1456_ (
    .A(_0436_),
    .B1(_0539_),
    .B2(_0542_),
    .ZN(_0703_)
  );
  AOI21_X1 _1457_ (
    .A(_0703_),
    .B1(_0436_),
    .B2(_0706_),
    .ZN(_0353_)
  );
  MUX2_X1 _1458_ (
    .A(_0912_[0]),
    .B(txf_rptr[0]),
    .S(_0436_),
    .Z(_0354_)
  );
  MUX2_X1 _1459_ (
    .A(\rxf_mem[5] [6]),
    .B(rx_shift[6]),
    .S(_0696_),
    .Z(_0355_)
  );
  MUX2_X1 _1460_ (
    .A(\rxf_mem[5] [5]),
    .B(rx_shift[5]),
    .S(_0696_),
    .Z(_0356_)
  );
  MUX2_X1 _1461_ (
    .A(\rxf_mem[5] [4]),
    .B(rx_shift[4]),
    .S(_0696_),
    .Z(_0357_)
  );
  MUX2_X1 _1462_ (
    .A(\rxf_mem[5] [3]),
    .B(rx_shift[3]),
    .S(_0696_),
    .Z(_0358_)
  );
  MUX2_X1 _1463_ (
    .A(rx_shift[7]),
    .B(\rxf_mem[3] [7]),
    .S(_0514_),
    .Z(_0359_)
  );
  MUX2_X1 _1464_ (
    .A(\rxf_mem[5] [2]),
    .B(rx_shift[2]),
    .S(_0696_),
    .Z(_0360_)
  );
  MUX2_X1 _1465_ (
    .A(\rxf_mem[5] [1]),
    .B(rx_shift[1]),
    .S(_0696_),
    .Z(_0361_)
  );
  MUX2_X1 _1466_ (
    .A(\rxf_mem[5] [0]),
    .B(rx_shift[0]),
    .S(_0696_),
    .Z(_0362_)
  );
  INV_X1 _1467_ (
    .A(rx_sub[0]),
    .ZN(_0704_)
  );
  INV_X1 _1468_ (
    .A(tx_sub[0]),
    .ZN(_0705_)
  );
  INV_X1 _1469_ (
    .A(txf_rptr[1]),
    .ZN(_0706_)
  );
  INV_X1 _1470_ (
    .A(txf_rptr[3]),
    .ZN(_0707_)
  );
  INV_X1 _1471_ (
    .A(txf_rptr[2]),
    .ZN(_0708_)
  );
  INV_X1 _1472_ (
    .A(rx_state[1]),
    .ZN(_0709_)
  );
  INV_X1 _1473_ (
    .A(rx_state[3]),
    .ZN(_0710_)
  );
  INV_X1 _1474_ (
    .A(rxf_wptr[1]),
    .ZN(_0711_)
  );
  INV_X1 _1475_ (
    .A(rxf_wptr[2]),
    .ZN(_0712_)
  );
  INV_X1 _1476_ (
    .A(rxf_wptr[3]),
    .ZN(_0713_)
  );
  INV_X1 _1477_ (
    .A(PWRITE),
    .ZN(_0714_)
  );
  INV_X1 _1478_ (
    .A(rxf_rptr[1]),
    .ZN(_0715_)
  );
  INV_X1 _1479_ (
    .A(rxf_rptr[2]),
    .ZN(_0716_)
  );
  INV_X1 _1480_ (
    .A(lcr_r[7]),
    .ZN(_0717_)
  );
  INV_X1 _1481_ (
    .A(PADDR[0]),
    .ZN(_0718_)
  );
  INV_X1 _1482_ (
    .A(PADDR[1]),
    .ZN(_0719_)
  );
  INV_X1 _1483_ (
    .A(PADDR[2]),
    .ZN(_0720_)
  );
  INV_X1 _1484_ (
    .A(txf_wptr[1]),
    .ZN(_0721_)
  );
  INV_X1 _1485_ (
    .A(txf_wptr[3]),
    .ZN(_0722_)
  );
  INV_X1 _1486_ (
    .A(dlm_r[6]),
    .ZN(_0723_)
  );
  INV_X1 _1487_ (
    .A(dll_r[4]),
    .ZN(_0724_)
  );
  INV_X1 _1488_ (
    .A(dll_r[3]),
    .ZN(_0725_)
  );
  INV_X1 _1489_ (
    .A(dlm_r[3]),
    .ZN(_0726_)
  );
  INV_X1 _1490_ (
    .A(dll_r[2]),
    .ZN(_0727_)
  );
  INV_X1 _1491_ (
    .A(lsr_oe_r),
    .ZN(_0728_)
  );
  INV_X1 _1492_ (
    .A(ier_r[0]),
    .ZN(_0729_)
  );
  INV_X1 _1493_ (
    .A(baud_cnt[5]),
    .ZN(_0730_)
  );
  INV_X1 _1494_ (
    .A(baud_cnt[1]),
    .ZN(_0731_)
  );
  INV_X1 _1495_ (
    .A(baud_cnt[0]),
    .ZN(_0732_)
  );
  INV_X1 _1496_ (
    .A(baud_cnt[2]),
    .ZN(_0733_)
  );
  INV_X1 _1497_ (
    .A(baud_cnt[6]),
    .ZN(_0734_)
  );
  INV_X1 _1498_ (
    .A(baud_cnt[7]),
    .ZN(_0735_)
  );
  INV_X1 _1499_ (
    .A(baud_cnt[10]),
    .ZN(_0736_)
  );
  INV_X1 _1500_ (
    .A(baud_cnt[9]),
    .ZN(_0737_)
  );
  INV_X1 _1501_ (
    .A(baud_cnt[8]),
    .ZN(_0738_)
  );
  INV_X1 _1502_ (
    .A(dlm_r[7]),
    .ZN(_0739_)
  );
  INV_X1 _1503_ (
    .A(baud_cnt[12]),
    .ZN(_0740_)
  );
  INV_X1 _1504_ (
    .A(baud_cnt[13]),
    .ZN(_0741_)
  );
  INV_X1 _1505_ (
    .A(tx_shift[1]),
    .ZN(_0742_)
  );
  INV_X1 _1506_ (
    .A(tx_bit_idx[0]),
    .ZN(_0743_)
  );
  INV_X1 _1507_ (
    .A(tx_bit_idx[1]),
    .ZN(_0744_)
  );
  INV_X1 _1508_ (
    .A(tx_bit_idx[2]),
    .ZN(_0745_)
  );
  INV_X1 _1509_ (
    .A(tx_shift[5]),
    .ZN(_0746_)
  );
  INV_X1 _1510_ (
    .A(tx_shift[7]),
    .ZN(_0747_)
  );
  INV_X1 _1511_ (
    .A(tx_state[1]),
    .ZN(_0748_)
  );
  INV_X1 _1512_ (
    .A(tx_state[0]),
    .ZN(_0749_)
  );
  INV_X1 _1513_ (
    .A(tx_state[3]),
    .ZN(_0750_)
  );
  INV_X1 _1514_ (
    .A(tx_sub[2]),
    .ZN(_0751_)
  );
  INV_X1 _1515_ (
    .A(tx_state[2]),
    .ZN(_0752_)
  );
  INV_X1 _1516_ (
    .A(_0012_),
    .ZN(_0753_)
  );
  INV_X1 _1517_ (
    .A(sin_s2),
    .ZN(_0754_)
  );
  INV_X1 _1518_ (
    .A(rx_bit_idx[0]),
    .ZN(_0755_)
  );
  INV_X1 _1519_ (
    .A(rx_bit_idx[1]),
    .ZN(_0756_)
  );
  INV_X1 _1520_ (
    .A(rx_bit_idx[2]),
    .ZN(_0757_)
  );
  INV_X1 _1521_ (
    .A(baud_tick),
    .ZN(_0758_)
  );
  INV_X1 _1522_ (
    .A(tx_sub[3]),
    .ZN(_0759_)
  );
  INV_X1 _1523_ (
    .A(SOUT),
    .ZN(_0760_)
  );
  NAND3_X1 _1524_ (
    .A1(PSEL),
    .A2(PENABLE),
    .A3(_0714_),
    .ZN(_0761_)
  );
  NAND2_X1 _1525_ (
    .A1(rxf_rptr[3]),
    .A2(rxf_rptr[2]),
    .ZN(_0762_)
  );
  NOR3_X1 _1526_ (
    .A1(rxf_rptr[0]),
    .A2(rxf_rptr[1]),
    .A3(_0762_),
    .ZN(_0763_)
  );
  NAND2_X1 _1527_ (
    .A1(rxf_rptr[0]),
    .A2(_0715_),
    .ZN(_0764_)
  );
  NOR2_X1 _1528_ (
    .A1(_0762_),
    .A2(_0764_),
    .ZN(_0765_)
  );
  NAND2_X1 _1529_ (
    .A1(rxf_rptr[3]),
    .A2(_0716_),
    .ZN(_0766_)
  );
  OR2_X1 _1530_ (
    .A1(rxf_rptr[0]),
    .A2(_0715_),
    .ZN(_0767_)
  );
  NOR2_X1 _1531_ (
    .A1(_0766_),
    .A2(_0767_),
    .ZN(_0768_)
  );
  NOR3_X1 _1532_ (
    .A1(rxf_rptr[0]),
    .A2(rxf_rptr[1]),
    .A3(_0766_),
    .ZN(_0769_)
  );
  OR2_X1 _1533_ (
    .A1(rxf_rptr[3]),
    .A2(_0716_),
    .ZN(_0770_)
  );
  NOR2_X1 _1534_ (
    .A1(_0767_),
    .A2(_0770_),
    .ZN(_0771_)
  );
  NAND2_X1 _1535_ (
    .A1(rxf_rptr[0]),
    .A2(rxf_rptr[1]),
    .ZN(_0772_)
  );
  NOR2_X1 _1536_ (
    .A1(_0766_),
    .A2(_0772_),
    .ZN(_0773_)
  );
  NOR3_X1 _1537_ (
    .A1(rxf_rptr[0]),
    .A2(rxf_rptr[1]),
    .A3(_0770_),
    .ZN(_0774_)
  );
  NOR2_X1 _1538_ (
    .A1(_0764_),
    .A2(_0766_),
    .ZN(_0775_)
  );
  NOR2_X1 _1539_ (
    .A1(_0762_),
    .A2(_0772_),
    .ZN(_0776_)
  );
  NOR3_X1 _1540_ (
    .A1(rxf_rptr[3]),
    .A2(rxf_rptr[2]),
    .A3(_0764_),
    .ZN(_0777_)
  );
  NOR2_X1 _1541_ (
    .A1(_0770_),
    .A2(_0772_),
    .ZN(_0778_)
  );
  NOR4_X1 _1542_ (
    .A1(rxf_rptr[0]),
    .A2(rxf_rptr[1]),
    .A3(rxf_rptr[3]),
    .A4(rxf_rptr[2]),
    .ZN(_0779_)
  );
  NOR3_X1 _1543_ (
    .A1(rxf_rptr[3]),
    .A2(rxf_rptr[2]),
    .A3(_0772_),
    .ZN(_0780_)
  );
  NOR2_X1 _1544_ (
    .A1(_0762_),
    .A2(_0767_),
    .ZN(_0781_)
  );
  NOR3_X1 _1545_ (
    .A1(rxf_rptr[3]),
    .A2(rxf_rptr[2]),
    .A3(_0767_),
    .ZN(_0782_)
  );
  NOR2_X1 _1546_ (
    .A1(_0764_),
    .A2(_0770_),
    .ZN(_0783_)
  );
  AOI222_X1 _1547_ (
    .A1(\rxf_mem[10] [6]),
    .A2(_0768_),
    .B1(_0769_),
    .B2(\rxf_mem[8] [6]),
    .C1(_0776_),
    .C2(\rxf_mem[15] [6]),
    .ZN(_0784_)
  );
  AOI22_X1 _1548_ (
    .A1(\rxf_mem[6] [6]),
    .A2(_0771_),
    .B1(_0778_),
    .B2(\rxf_mem[7] [6]),
    .ZN(_0785_)
  );
  NAND2_X1 _1549_ (
    .A1(_0784_),
    .A2(_0785_),
    .ZN(_0786_)
  );
  AOI222_X1 _1550_ (
    .A1(\rxf_mem[13] [6]),
    .A2(_0765_),
    .B1(_0773_),
    .B2(\rxf_mem[11] [6]),
    .C1(\rxf_mem[2] [6]),
    .C2(_0782_),
    .ZN(_0787_)
  );
  AOI221_X1 _1551_ (
    .A(lcr_r[7]),
    .B1(_0763_),
    .B2(\rxf_mem[12] [6]),
    .C1(_0774_),
    .C2(\rxf_mem[4] [6]),
    .ZN(_0788_)
  );
  AOI222_X1 _1552_ (
    .A1(\rxf_mem[1] [6]),
    .A2(_0777_),
    .B1(_0779_),
    .B2(\rxf_mem[0] [6]),
    .C1(_0783_),
    .C2(\rxf_mem[5] [6]),
    .ZN(_0789_)
  );
  AOI222_X1 _1553_ (
    .A1(\rxf_mem[9] [6]),
    .A2(_0775_),
    .B1(_0780_),
    .B2(\rxf_mem[3] [6]),
    .C1(_0781_),
    .C2(\rxf_mem[14] [6]),
    .ZN(_0790_)
  );
  NAND4_X1 _1554_ (
    .A1(_0787_),
    .A2(_0788_),
    .A3(_0789_),
    .A4(_0790_),
    .ZN(_0791_)
  );
  NOR3_X1 _1555_ (
    .A1(PADDR[0]),
    .A2(PADDR[1]),
    .A3(PADDR[2]),
    .ZN(_0792_)
  );
  NAND3_X1 _1556_ (
    .A1(_0718_),
    .A2(_0719_),
    .A3(_0720_),
    .ZN(_0793_)
  );
  OAI221_X1 _1557_ (
    .A(_0792_),
    .B1(_0791_),
    .B2(_0786_),
    .C1(_0717_),
    .C2(dll_r[6]),
    .ZN(_0794_)
  );
  NAND3_X1 _1558_ (
    .A1(PADDR[0]),
    .A2(_0719_),
    .A3(PADDR[2]),
    .ZN(_0795_)
  );
  XOR2_X1 _1559_ (
    .A(txf_rptr[1]),
    .B(txf_wptr[1]),
    .Z(_0796_)
  );
  XOR2_X1 _1560_ (
    .A(txf_rptr[0]),
    .B(txf_wptr[0]),
    .Z(_0797_)
  );
  XOR2_X1 _1561_ (
    .A(txf_rptr[3]),
    .B(txf_wptr[3]),
    .Z(_0798_)
  );
  XOR2_X1 _1562_ (
    .A(txf_rptr[2]),
    .B(txf_wptr[2]),
    .Z(_0799_)
  );
  NOR4_X1 _1563_ (
    .A1(_0796_),
    .A2(_0797_),
    .A3(_0798_),
    .A4(_0799_),
    .ZN(_0800_)
  );
  XOR2_X1 _1564_ (
    .A(txf_rptr[4]),
    .B(txf_wptr[4]),
    .Z(_0801_)
  );
  XNOR2_X1 _1565_ (
    .A(txf_rptr[4]),
    .B(txf_wptr[4]),
    .ZN(_0802_)
  );
  NAND2_X1 _1566_ (
    .A1(_0800_),
    .A2(_0802_),
    .ZN(_0803_)
  );
  NOR2_X1 _1567_ (
    .A1(_0795_),
    .A2(_0803_),
    .ZN(_0804_)
  );
  NOR3_X1 _1568_ (
    .A1(_0718_),
    .A2(PADDR[1]),
    .A3(PADDR[2]),
    .ZN(_0805_)
  );
  AND2_X1 _1569_ (
    .A1(lcr_r[7]),
    .A2(_0805_),
    .ZN(_0806_)
  );
  INV_X1 _1570_ (
    .A(_0806_),
    .ZN(_0807_)
  );
  NAND2_X1 _1571_ (
    .A1(PADDR[0]),
    .A2(PADDR[1]),
    .ZN(_0808_)
  );
  NOR2_X1 _1572_ (
    .A1(PADDR[2]),
    .A2(_0808_),
    .ZN(_0809_)
  );
  NAND2_X1 _1573_ (
    .A1(lcr_r[6]),
    .A2(_0809_),
    .ZN(_0810_)
  );
  NOR2_X1 _1574_ (
    .A1(PADDR[0]),
    .A2(_0719_),
    .ZN(_0811_)
  );
  NOR3_X1 _1575_ (
    .A1(PADDR[0]),
    .A2(_0719_),
    .A3(PADDR[2]),
    .ZN(_0812_)
  );
  NOR2_X1 _1576_ (
    .A1(_0720_),
    .A2(_0808_),
    .ZN(_0813_)
  );
  AOI221_X1 _1577_ (
    .A(_0812_),
    .B1(_0813_),
    .B2(scr_r[6]),
    .C1(RIN),
    .C2(_0811_),
    .ZN(_0814_)
  );
  NAND2_X1 _1578_ (
    .A1(_0810_),
    .A2(_0814_),
    .ZN(_0815_)
  );
  AOI211_X1 _1579_ (
    .A(_0804_),
    .B(_0815_),
    .C1(_0806_),
    .C2(dlm_r[6]),
    .ZN(_0816_)
  );
  AOI21_X1 _1580_ (
    .A(_0761_),
    .B1(_0794_),
    .B2(_0816_),
    .ZN(PRDATA[6])
  );
  AOI222_X1 _1581_ (
    .A1(\rxf_mem[12] [5]),
    .A2(_0763_),
    .B1(_0776_),
    .B2(\rxf_mem[15] [5]),
    .C1(_0779_),
    .C2(\rxf_mem[0] [5]),
    .ZN(_0817_)
  );
  AOI22_X1 _1582_ (
    .A1(\rxf_mem[1] [5]),
    .A2(_0777_),
    .B1(_0778_),
    .B2(\rxf_mem[7] [5]),
    .ZN(_0818_)
  );
  AOI222_X1 _1583_ (
    .A1(\rxf_mem[8] [5]),
    .A2(_0769_),
    .B1(_0773_),
    .B2(\rxf_mem[11] [5]),
    .C1(\rxf_mem[10] [5]),
    .C2(_0768_),
    .ZN(_0819_)
  );
  AOI222_X1 _1584_ (
    .A1(\rxf_mem[4] [5]),
    .A2(_0774_),
    .B1(_0775_),
    .B2(\rxf_mem[9] [5]),
    .C1(_0781_),
    .C2(\rxf_mem[14] [5]),
    .ZN(_0820_)
  );
  AOI22_X1 _1585_ (
    .A1(\rxf_mem[6] [5]),
    .A2(_0771_),
    .B1(_0782_),
    .B2(\rxf_mem[2] [5]),
    .ZN(_0821_)
  );
  AOI222_X1 _1586_ (
    .A1(\rxf_mem[13] [5]),
    .A2(_0765_),
    .B1(_0780_),
    .B2(\rxf_mem[3] [5]),
    .C1(_0783_),
    .C2(\rxf_mem[5] [5]),
    .ZN(_0822_)
  );
  NAND4_X1 _1587_ (
    .A1(_0819_),
    .A2(_0820_),
    .A3(_0821_),
    .A4(_0822_),
    .ZN(_0823_)
  );
  NAND3_X1 _1588_ (
    .A1(_0717_),
    .A2(_0817_),
    .A3(_0818_),
    .ZN(_0824_)
  );
  OAI221_X1 _1589_ (
    .A(_0792_),
    .B1(_0823_),
    .B2(_0824_),
    .C1(dll_r[5]),
    .C2(_0717_),
    .ZN(_0825_)
  );
  NAND3_X1 _1590_ (
    .A1(PADDR[2]),
    .A2(DSRN),
    .A3(_0811_),
    .ZN(_0826_)
  );
  AOI22_X1 _1591_ (
    .A1(lcr_r[5]),
    .A2(_0809_),
    .B1(_0813_),
    .B2(scr_r[5]),
    .ZN(_0827_)
  );
  NAND2_X1 _1592_ (
    .A1(_0826_),
    .A2(_0827_),
    .ZN(_0828_)
  );
  AOI211_X1 _1593_ (
    .A(_0804_),
    .B(_0828_),
    .C1(_0806_),
    .C2(dlm_r[5]),
    .ZN(_0829_)
  );
  AOI21_X1 _1594_ (
    .A(_0761_),
    .B1(_0825_),
    .B2(_0829_),
    .ZN(PRDATA[5])
  );
  AOI222_X1 _1595_ (
    .A1(\rxf_mem[12] [4]),
    .A2(_0763_),
    .B1(_0768_),
    .B2(\rxf_mem[10] [4]),
    .C1(_0776_),
    .C2(\rxf_mem[15] [4]),
    .ZN(_0830_)
  );
  AOI22_X1 _1596_ (
    .A1(\rxf_mem[11] [4]),
    .A2(_0773_),
    .B1(_0783_),
    .B2(\rxf_mem[5] [4]),
    .ZN(_0831_)
  );
  AOI222_X1 _1597_ (
    .A1(\rxf_mem[8] [4]),
    .A2(_0769_),
    .B1(_0777_),
    .B2(\rxf_mem[1] [4]),
    .C1(_0780_),
    .C2(\rxf_mem[3] [4]),
    .ZN(_0832_)
  );
  AOI221_X1 _1598_ (
    .A(lcr_r[7]),
    .B1(\rxf_mem[9] [4]),
    .B2(_0775_),
    .C1(_0779_),
    .C2(\rxf_mem[0] [4]),
    .ZN(_0833_)
  );
  AOI222_X1 _1599_ (
    .A1(\rxf_mem[13] [4]),
    .A2(_0765_),
    .B1(_0778_),
    .B2(\rxf_mem[7] [4]),
    .C1(_0781_),
    .C2(\rxf_mem[14] [4]),
    .ZN(_0834_)
  );
  AOI222_X1 _1600_ (
    .A1(\rxf_mem[6] [4]),
    .A2(_0771_),
    .B1(_0774_),
    .B2(\rxf_mem[4] [4]),
    .C1(_0782_),
    .C2(\rxf_mem[2] [4]),
    .ZN(_0835_)
  );
  AND4_X1 _1601_ (
    .A1(_0832_),
    .A2(_0833_),
    .A3(_0834_),
    .A4(_0835_),
    .ZN(_0836_)
  );
  NAND3_X1 _1602_ (
    .A1(_0830_),
    .A2(_0831_),
    .A3(_0836_),
    .ZN(_0837_)
  );
  AOI21_X1 _1603_ (
    .A(_0793_),
    .B1(_0724_),
    .B2(lcr_r[7]),
    .ZN(_0838_)
  );
  AND3_X1 _1604_ (
    .A1(PADDR[2]),
    .A2(CTSN),
    .A3(_0811_),
    .ZN(_0839_)
  );
  NOR3_X1 _1605_ (
    .A1(PADDR[0]),
    .A2(PADDR[1]),
    .A3(_0720_),
    .ZN(_0840_)
  );
  AOI221_X1 _1606_ (
    .A(_0839_),
    .B1(_0840_),
    .B2(mcr_r[4]),
    .C1(_0813_),
    .C2(scr_r[4]),
    .ZN(_0841_)
  );
  AOI222_X1 _1607_ (
    .A1(dlm_r[4]),
    .A2(_0806_),
    .B1(_0837_),
    .B2(_0838_),
    .C1(_0809_),
    .C2(lcr_r[4]),
    .ZN(_0842_)
  );
  AOI21_X1 _1608_ (
    .A(_0761_),
    .B1(_0841_),
    .B2(_0842_),
    .ZN(PRDATA[4])
  );
  AOI222_X1 _1609_ (
    .A1(\rxf_mem[15] [3]),
    .A2(_0776_),
    .B1(_0779_),
    .B2(\rxf_mem[0] [3]),
    .C1(\rxf_mem[11] [3]),
    .C2(_0773_),
    .ZN(_0843_)
  );
  AOI22_X1 _1610_ (
    .A1(\rxf_mem[1] [3]),
    .A2(_0777_),
    .B1(_0780_),
    .B2(\rxf_mem[3] [3]),
    .ZN(_0844_)
  );
  NAND2_X1 _1611_ (
    .A1(_0843_),
    .A2(_0844_),
    .ZN(_0845_)
  );
  AOI222_X1 _1612_ (
    .A1(\rxf_mem[9] [3]),
    .A2(_0775_),
    .B1(_0783_),
    .B2(\rxf_mem[5] [3]),
    .C1(_0778_),
    .C2(\rxf_mem[7] [3]),
    .ZN(_0846_)
  );
  AOI221_X1 _1613_ (
    .A(lcr_r[7]),
    .B1(\rxf_mem[10] [3]),
    .B2(_0768_),
    .C1(_0769_),
    .C2(\rxf_mem[8] [3]),
    .ZN(_0847_)
  );
  AOI222_X1 _1614_ (
    .A1(\rxf_mem[12] [3]),
    .A2(_0763_),
    .B1(_0765_),
    .B2(\rxf_mem[13] [3]),
    .C1(\rxf_mem[6] [3]),
    .C2(_0771_),
    .ZN(_0848_)
  );
  AOI222_X1 _1615_ (
    .A1(\rxf_mem[14] [3]),
    .A2(_0781_),
    .B1(_0782_),
    .B2(\rxf_mem[2] [3]),
    .C1(\rxf_mem[4] [3]),
    .C2(_0774_),
    .ZN(_0849_)
  );
  NAND4_X1 _1616_ (
    .A1(_0846_),
    .A2(_0847_),
    .A3(_0848_),
    .A4(_0849_),
    .ZN(_0850_)
  );
  OAI221_X1 _1617_ (
    .A(_0792_),
    .B1(_0845_),
    .B2(_0850_),
    .C1(dll_r[3]),
    .C2(_0717_),
    .ZN(_0851_)
  );
  MUX2_X1 _1618_ (
    .A(ier_r[3]),
    .B(dlm_r[3]),
    .S(lcr_r[7]),
    .Z(_0852_)
  );
  AOI22_X1 _1619_ (
    .A1(mcr_r[3]),
    .A2(_0840_),
    .B1(_0852_),
    .B2(_0805_),
    .ZN(_0853_)
  );
  INV_X1 _1620_ (
    .A(_0853_),
    .ZN(_0854_)
  );
  AOI221_X1 _1621_ (
    .A(_0854_),
    .B1(_0813_),
    .B2(scr_r[3]),
    .C1(lcr_r[3]),
    .C2(_0809_),
    .ZN(_0855_)
  );
  AOI21_X1 _1622_ (
    .A(_0761_),
    .B1(_0851_),
    .B2(_0855_),
    .ZN(PRDATA[3])
  );
  AOI22_X1 _1623_ (
    .A1(\rxf_mem[6] [2]),
    .A2(_0771_),
    .B1(_0780_),
    .B2(\rxf_mem[3] [2]),
    .ZN(_0856_)
  );
  AOI222_X1 _1624_ (
    .A1(\rxf_mem[13] [2]),
    .A2(_0765_),
    .B1(_0774_),
    .B2(\rxf_mem[4] [2]),
    .C1(_0778_),
    .C2(\rxf_mem[7] [2]),
    .ZN(_0857_)
  );
  AOI222_X1 _1625_ (
    .A1(\rxf_mem[8] [2]),
    .A2(_0769_),
    .B1(_0775_),
    .B2(\rxf_mem[9] [2]),
    .C1(\rxf_mem[12] [2]),
    .C2(_0763_),
    .ZN(_0858_)
  );
  AOI221_X1 _1626_ (
    .A(lcr_r[7]),
    .B1(\rxf_mem[11] [2]),
    .B2(_0773_),
    .C1(_0777_),
    .C2(\rxf_mem[1] [2]),
    .ZN(_0859_)
  );
  AOI222_X1 _1627_ (
    .A1(\rxf_mem[0] [2]),
    .A2(_0779_),
    .B1(_0783_),
    .B2(\rxf_mem[5] [2]),
    .C1(_0782_),
    .C2(\rxf_mem[2] [2]),
    .ZN(_0860_)
  );
  AOI222_X1 _1628_ (
    .A1(\rxf_mem[15] [2]),
    .A2(_0776_),
    .B1(_0781_),
    .B2(\rxf_mem[14] [2]),
    .C1(\rxf_mem[10] [2]),
    .C2(_0768_),
    .ZN(_0861_)
  );
  AND4_X1 _1629_ (
    .A1(_0858_),
    .A2(_0859_),
    .A3(_0860_),
    .A4(_0861_),
    .ZN(_0862_)
  );
  NAND3_X1 _1630_ (
    .A1(_0856_),
    .A2(_0857_),
    .A3(_0862_),
    .ZN(_0863_)
  );
  AOI21_X1 _1631_ (
    .A(_0793_),
    .B1(_0727_),
    .B2(lcr_r[7]),
    .ZN(_0864_)
  );
  NAND2_X1 _1632_ (
    .A1(lsr_oe_r),
    .A2(ier_r[2]),
    .ZN(_0865_)
  );
  XNOR2_X1 _1633_ (
    .A(rxf_wptr[1]),
    .B(rxf_rptr[1]),
    .ZN(_0866_)
  );
  XNOR2_X1 _1634_ (
    .A(rxf_wptr[0]),
    .B(rxf_rptr[0]),
    .ZN(_0867_)
  );
  XNOR2_X1 _1635_ (
    .A(rxf_wptr[2]),
    .B(rxf_rptr[2]),
    .ZN(_0868_)
  );
  XNOR2_X1 _1636_ (
    .A(rxf_wptr[3]),
    .B(rxf_rptr[3]),
    .ZN(_0869_)
  );
  NAND4_X1 _1637_ (
    .A1(_0866_),
    .A2(_0867_),
    .A3(_0868_),
    .A4(_0869_),
    .ZN(_0870_)
  );
  XNOR2_X1 _1638_ (
    .A(rxf_wptr[4]),
    .B(rxf_rptr[4]),
    .ZN(_0871_)
  );
  XOR2_X1 _1639_ (
    .A(rxf_wptr[4]),
    .B(rxf_rptr[4]),
    .Z(_0872_)
  );
  NOR2_X1 _1640_ (
    .A1(_0870_),
    .A2(_0872_),
    .ZN(_0873_)
  );
  OAI21_X1 _1641_ (
    .A(_0865_),
    .B1(_0873_),
    .B2(_0729_),
    .ZN(_0874_)
  );
  MUX2_X1 _1642_ (
    .A(ier_r[2]),
    .B(dlm_r[2]),
    .S(lcr_r[7]),
    .Z(_0875_)
  );
  AOI222_X1 _1643_ (
    .A1(scr_r[2]),
    .A2(_0813_),
    .B1(_0874_),
    .B2(_0812_),
    .C1(_0840_),
    .C2(mcr_r[2]),
    .ZN(_0876_)
  );
  AOI222_X1 _1644_ (
    .A1(lcr_r[2]),
    .A2(_0809_),
    .B1(_0863_),
    .B2(_0864_),
    .C1(_0875_),
    .C2(_0805_),
    .ZN(_0877_)
  );
  AOI21_X1 _1645_ (
    .A(_0761_),
    .B1(_0876_),
    .B2(_0877_),
    .ZN(PRDATA[2])
  );
  NAND2_X1 _1646_ (
    .A1(\rxf_mem[12] [1]),
    .A2(_0763_),
    .ZN(_0878_)
  );
  AOI222_X1 _1647_ (
    .A1(\rxf_mem[11] [1]),
    .A2(_0773_),
    .B1(_0777_),
    .B2(\rxf_mem[1] [1]),
    .C1(\rxf_mem[3] [1]),
    .C2(_0780_),
    .ZN(_0879_)
  );
  AOI22_X1 _1648_ (
    .A1(\rxf_mem[6] [1]),
    .A2(_0771_),
    .B1(_0774_),
    .B2(\rxf_mem[4] [1]),
    .ZN(_0880_)
  );
  AOI22_X1 _1649_ (
    .A1(\rxf_mem[13] [1]),
    .A2(_0765_),
    .B1(_0775_),
    .B2(\rxf_mem[9] [1]),
    .ZN(_0881_)
  );
  NAND3_X1 _1650_ (
    .A1(_0879_),
    .A2(_0880_),
    .A3(_0881_),
    .ZN(_0882_)
  );
  AOI222_X1 _1651_ (
    .A1(\rxf_mem[10] [1]),
    .A2(_0768_),
    .B1(_0776_),
    .B2(\rxf_mem[15] [1]),
    .C1(_0781_),
    .C2(\rxf_mem[14] [1]),
    .ZN(_0883_)
  );
  AOI221_X1 _1652_ (
    .A(lcr_r[7]),
    .B1(\rxf_mem[0] [1]),
    .B2(_0779_),
    .C1(_0782_),
    .C2(\rxf_mem[2] [1]),
    .ZN(_0884_)
  );
  AOI222_X1 _1653_ (
    .A1(\rxf_mem[8] [1]),
    .A2(_0769_),
    .B1(_0778_),
    .B2(\rxf_mem[7] [1]),
    .C1(\rxf_mem[5] [1]),
    .C2(_0783_),
    .ZN(_0885_)
  );
  NAND4_X1 _1654_ (
    .A1(_0878_),
    .A2(_0883_),
    .A3(_0884_),
    .A4(_0885_),
    .ZN(_0886_)
  );
  OAI221_X1 _1655_ (
    .A(_0792_),
    .B1(_0882_),
    .B2(_0886_),
    .C1(dll_r[1]),
    .C2(_0717_),
    .ZN(_0887_)
  );
  AND3_X1 _1656_ (
    .A1(ier_r[1]),
    .A2(_0800_),
    .A3(_0802_),
    .ZN(_0888_)
  );
  OAI21_X1 _1657_ (
    .A(_0888_),
    .B1(_0873_),
    .B2(_0729_),
    .ZN(_0889_)
  );
  NAND2_X1 _1658_ (
    .A1(_0865_),
    .A2(_0889_),
    .ZN(_0890_)
  );
  NAND2_X1 _1659_ (
    .A1(scr_r[1]),
    .A2(_0813_),
    .ZN(_0891_)
  );
  MUX2_X1 _1660_ (
    .A(ier_r[1]),
    .B(dlm_r[1]),
    .S(lcr_r[7]),
    .Z(_0892_)
  );
  AOI222_X1 _1661_ (
    .A1(lcr_r[1]),
    .A2(_0809_),
    .B1(_0892_),
    .B2(_0805_),
    .C1(_0840_),
    .C2(mcr_r[1]),
    .ZN(_0893_)
  );
  OAI211_X1 _1662_ (
    .A(_0891_),
    .B(_0893_),
    .C1(_0728_),
    .C2(_0795_),
    .ZN(_0894_)
  );
  AOI21_X1 _1663_ (
    .A(_0894_),
    .B1(_0890_),
    .B2(_0812_),
    .ZN(_0895_)
  );
  AOI21_X1 _1664_ (
    .A(_0761_),
    .B1(_0887_),
    .B2(_0895_),
    .ZN(PRDATA[1])
  );
  NOR2_X1 _1665_ (
    .A1(_0874_),
    .A2(_0888_),
    .ZN(_0896_)
  );
  INV_X1 _1666_ (
    .A(_0896_),
    .ZN(INT)
  );
  AOI222_X1 _1667_ (
    .A1(\rxf_mem[12] [0]),
    .A2(_0763_),
    .B1(_0774_),
    .B2(\rxf_mem[4] [0]),
    .C1(_0779_),
    .C2(\rxf_mem[0] [0]),
    .ZN(_0897_)
  );
  AOI22_X1 _1668_ (
    .A1(\rxf_mem[13] [0]),
    .A2(_0765_),
    .B1(_0781_),
    .B2(\rxf_mem[14] [0]),
    .ZN(_0898_)
  );
  NAND2_X1 _1669_ (
    .A1(_0897_),
    .A2(_0898_),
    .ZN(_0899_)
  );
  AOI222_X1 _1670_ (
    .A1(\rxf_mem[10] [0]),
    .A2(_0768_),
    .B1(_0776_),
    .B2(\rxf_mem[15] [0]),
    .C1(_0777_),
    .C2(\rxf_mem[1] [0]),
    .ZN(_0900_)
  );
  AOI221_X1 _1671_ (
    .A(lcr_r[7]),
    .B1(\rxf_mem[6] [0]),
    .B2(_0771_),
    .C1(_0778_),
    .C2(\rxf_mem[7] [0]),
    .ZN(_0901_)
  );
  AOI222_X1 _1672_ (
    .A1(\rxf_mem[11] [0]),
    .A2(_0773_),
    .B1(_0782_),
    .B2(\rxf_mem[2] [0]),
    .C1(_0783_),
    .C2(\rxf_mem[5] [0]),
    .ZN(_0902_)
  );
  AOI222_X1 _1673_ (
    .A1(\rxf_mem[8] [0]),
    .A2(_0769_),
    .B1(_0780_),
    .B2(\rxf_mem[3] [0]),
    .C1(_0775_),
    .C2(\rxf_mem[9] [0]),
    .ZN(_0903_)
  );
  NAND4_X1 _1674_ (
    .A1(_0900_),
    .A2(_0901_),
    .A3(_0902_),
    .A4(_0903_),
    .ZN(_0904_)
  );
  OAI221_X1 _1675_ (
    .A(_0792_),
    .B1(_0899_),
    .B2(_0904_),
    .C1(dll_r[0]),
    .C2(_0717_),
    .ZN(_0905_)
  );
  MUX2_X1 _1676_ (
    .A(ier_r[0]),
    .B(dlm_r[0]),
    .S(lcr_r[7]),
    .Z(_0906_)
  );
  AOI22_X1 _1677_ (
    .A1(scr_r[0]),
    .A2(_0813_),
    .B1(_0906_),
    .B2(_0805_),
    .ZN(_0907_)
  );
  AOI22_X1 _1678_ (
    .A1(lcr_r[0]),
    .A2(_0809_),
    .B1(_0840_),
    .B2(mcr_r[0]),
    .ZN(_0908_)
  );
  OAI211_X1 _1679_ (
    .A(_0907_),
    .B(_0908_),
    .C1(_0795_),
    .C2(_0873_),
    .ZN(_0909_)
  );
  AOI21_X1 _1680_ (
    .A(_0909_),
    .B1(_0896_),
    .B2(_0812_),
    .ZN(_0363_)
  );
  AOI21_X1 _1681_ (
    .A(_0761_),
    .B1(_0905_),
    .B2(_0363_),
    .ZN(PRDATA[0])
  );
  NAND2_X1 _1682_ (
    .A1(_0726_),
    .A2(baud_cnt[11]),
    .ZN(_0364_)
  );
  NAND2_X1 _1683_ (
    .A1(dlm_r[2]),
    .A2(_0736_),
    .ZN(_0365_)
  );
  OR2_X1 _1684_ (
    .A1(dll_r[7]),
    .A2(_0735_),
    .ZN(_0366_)
  );
  NAND2_X1 _1685_ (
    .A1(dll_r[6]),
    .A2(_0734_),
    .ZN(_0367_)
  );
  AOI22_X1 _1686_ (
    .A1(dll_r[1]),
    .A2(_0731_),
    .B1(_0732_),
    .B2(dll_r[0]),
    .ZN(_0368_)
  );
  OAI22_X1 _1687_ (
    .A1(dll_r[1]),
    .A2(_0731_),
    .B1(_0733_),
    .B2(dll_r[2]),
    .ZN(_0369_)
  );
  OAI222_X1 _1688_ (
    .A1(_0725_),
    .A2(baud_cnt[3]),
    .B1(_0368_),
    .B2(_0369_),
    .C1(baud_cnt[2]),
    .C2(_0727_),
    .ZN(_0370_)
  );
  AOI22_X1 _1689_ (
    .A1(_0724_),
    .A2(baud_cnt[4]),
    .B1(baud_cnt[3]),
    .B2(_0725_),
    .ZN(_0371_)
  );
  NOR2_X1 _1690_ (
    .A1(_0724_),
    .A2(baud_cnt[4]),
    .ZN(_0372_)
  );
  AOI221_X1 _1691_ (
    .A(_0372_),
    .B1(_0371_),
    .B2(_0370_),
    .C1(dll_r[5]),
    .C2(_0730_),
    .ZN(_0373_)
  );
  OAI22_X1 _1692_ (
    .A1(dll_r[5]),
    .A2(_0730_),
    .B1(_0734_),
    .B2(dll_r[6]),
    .ZN(_0374_)
  );
  OAI21_X1 _1693_ (
    .A(_0367_),
    .B1(_0373_),
    .B2(_0374_),
    .ZN(_0375_)
  );
  OAI22_X1 _1694_ (
    .A1(dlm_r[1]),
    .A2(_0737_),
    .B1(_0738_),
    .B2(dlm_r[0]),
    .ZN(_0376_)
  );
  NAND2_X1 _1695_ (
    .A1(dlm_r[1]),
    .A2(_0737_),
    .ZN(_0377_)
  );
  AOI22_X1 _1696_ (
    .A1(dll_r[7]),
    .A2(_0735_),
    .B1(_0738_),
    .B2(dlm_r[0]),
    .ZN(_0378_)
  );
  NAND2_X1 _1697_ (
    .A1(_0377_),
    .A2(_0378_),
    .ZN(_0379_)
  );
  AOI211_X1 _1698_ (
    .A(_0376_),
    .B(_0379_),
    .C1(_0366_),
    .C2(_0375_),
    .ZN(_0380_)
  );
  NAND2_X1 _1699_ (
    .A1(_0376_),
    .A2(_0377_),
    .ZN(_0381_)
  );
  OAI21_X1 _1700_ (
    .A(_0381_),
    .B1(_0736_),
    .B2(dlm_r[2]),
    .ZN(_0382_)
  );
  OAI21_X1 _1701_ (
    .A(_0365_),
    .B1(_0380_),
    .B2(_0382_),
    .ZN(_0383_)
  );
  AOI22_X1 _1702_ (
    .A1(_0739_),
    .A2(baud_cnt[15]),
    .B1(baud_cnt[14]),
    .B2(_0723_),
    .ZN(_0384_)
  );
  NOR2_X1 _1703_ (
    .A1(_0739_),
    .A2(baud_cnt[15]),
    .ZN(_0385_)
  );
  OAI21_X1 _1704_ (
    .A(_0384_),
    .B1(baud_cnt[14]),
    .B2(_0723_),
    .ZN(_0386_)
  );
  OR2_X1 _1705_ (
    .A1(_0385_),
    .A2(_0386_),
    .ZN(_0387_)
  );
  OAI22_X1 _1706_ (
    .A1(dlm_r[4]),
    .A2(_0740_),
    .B1(_0741_),
    .B2(dlm_r[5]),
    .ZN(_0388_)
  );
  NAND2_X1 _1707_ (
    .A1(dlm_r[5]),
    .A2(_0741_),
    .ZN(_0389_)
  );
  NAND2_X1 _1708_ (
    .A1(dlm_r[4]),
    .A2(_0740_),
    .ZN(_0390_)
  );
  OAI211_X1 _1709_ (
    .A(_0389_),
    .B(_0390_),
    .C1(_0726_),
    .C2(baud_cnt[11]),
    .ZN(_0391_)
  );
  OR3_X1 _1710_ (
    .A1(_0387_),
    .A2(_0388_),
    .A3(_0391_),
    .ZN(_0392_)
  );
  AOI21_X1 _1711_ (
    .A(_0392_),
    .B1(_0383_),
    .B2(_0364_),
    .ZN(_0393_)
  );
  NAND2_X1 _1712_ (
    .A1(_0388_),
    .A2(_0389_),
    .ZN(_0394_)
  );
  OAI22_X1 _1713_ (
    .A1(_0384_),
    .A2(_0385_),
    .B1(_0387_),
    .B2(_0394_),
    .ZN(_0395_)
  );
  OR2_X1 _1714_ (
    .A1(_0393_),
    .A2(_0395_),
    .ZN(_0001_)
  );
  NOR2_X1 _1715_ (
    .A1(_0731_),
    .A2(_0732_),
    .ZN(_0396_)
  );
  AND4_X1 _1716_ (
    .A1(baud_cnt[1]),
    .A2(baud_cnt[0]),
    .A3(baud_cnt[3]),
    .A4(baud_cnt[2]),
    .ZN(_0397_)
  );
  AND2_X1 _1717_ (
    .A1(baud_cnt[4]),
    .A2(_0397_),
    .ZN(_0398_)
  );
  NAND2_X1 _1718_ (
    .A1(baud_cnt[5]),
    .A2(_0398_),
    .ZN(_0399_)
  );
  NAND3_X1 _1719_ (
    .A1(baud_cnt[5]),
    .A2(baud_cnt[6]),
    .A3(_0398_),
    .ZN(_0400_)
  );
  NOR2_X1 _1720_ (
    .A1(_0735_),
    .A2(_0400_),
    .ZN(_0401_)
  );
  NAND2_X1 _1721_ (
    .A1(baud_cnt[8]),
    .A2(_0401_),
    .ZN(_0402_)
  );
  NAND3_X1 _1722_ (
    .A1(baud_cnt[9]),
    .A2(baud_cnt[8]),
    .A3(_0401_),
    .ZN(_0403_)
  );
  AND4_X1 _1723_ (
    .A1(baud_cnt[10]),
    .A2(baud_cnt[9]),
    .A3(baud_cnt[8]),
    .A4(_0401_),
    .ZN(_0404_)
  );
  NAND2_X1 _1724_ (
    .A1(baud_cnt[11]),
    .A2(_0404_),
    .ZN(_0405_)
  );
  NAND3_X1 _1725_ (
    .A1(baud_cnt[11]),
    .A2(baud_cnt[12]),
    .A3(_0404_),
    .ZN(_0406_)
  );
  NOR2_X1 _1726_ (
    .A1(_0741_),
    .A2(_0406_),
    .ZN(_0407_)
  );
  XNOR2_X1 _1727_ (
    .A(baud_cnt[14]),
    .B(_0407_),
    .ZN(_0408_)
  );
  NOR3_X1 _1728_ (
    .A1(_0393_),
    .A2(_0395_),
    .A3(_0408_),
    .ZN(_0000_[14])
  );
  AND2_X1 _1729_ (
    .A1(_0741_),
    .A2(_0406_),
    .ZN(_0409_)
  );
  NOR4_X1 _1730_ (
    .A1(_0393_),
    .A2(_0395_),
    .A3(_0407_),
    .A4(_0409_),
    .ZN(_0000_[13])
  );
  XNOR2_X1 _1731_ (
    .A(_0740_),
    .B(_0405_),
    .ZN(_0410_)
  );
  NOR3_X1 _1732_ (
    .A1(_0393_),
    .A2(_0395_),
    .A3(_0410_),
    .ZN(_0000_[12])
  );
  XNOR2_X1 _1733_ (
    .A(baud_cnt[11]),
    .B(_0404_),
    .ZN(_0411_)
  );
  NOR3_X1 _1734_ (
    .A1(_0393_),
    .A2(_0395_),
    .A3(_0411_),
    .ZN(_0000_[11])
  );
  AND2_X1 _1735_ (
    .A1(_0736_),
    .A2(_0403_),
    .ZN(_0412_)
  );
  NOR4_X1 _1736_ (
    .A1(_0393_),
    .A2(_0395_),
    .A3(_0404_),
    .A4(_0412_),
    .ZN(_0000_[10])
  );
  XNOR2_X1 _1737_ (
    .A(_0737_),
    .B(_0402_),
    .ZN(_0413_)
  );
  NOR3_X1 _1738_ (
    .A1(_0393_),
    .A2(_0395_),
    .A3(_0413_),
    .ZN(_0000_[9])
  );
  XNOR2_X1 _1739_ (
    .A(baud_cnt[8]),
    .B(_0401_),
    .ZN(_0414_)
  );
  NOR3_X1 _1740_ (
    .A1(_0393_),
    .A2(_0395_),
    .A3(_0414_),
    .ZN(_0000_[8])
  );
  AND2_X1 _1741_ (
    .A1(_0735_),
    .A2(_0400_),
    .ZN(_0415_)
  );
  NOR4_X1 _1742_ (
    .A1(_0393_),
    .A2(_0395_),
    .A3(_0401_),
    .A4(_0415_),
    .ZN(_0000_[7])
  );
  XNOR2_X1 _1743_ (
    .A(_0734_),
    .B(_0399_),
    .ZN(_0416_)
  );
  NOR3_X1 _1744_ (
    .A1(_0393_),
    .A2(_0395_),
    .A3(_0416_),
    .ZN(_0000_[6])
  );
  XNOR2_X1 _1745_ (
    .A(baud_cnt[5]),
    .B(_0398_),
    .ZN(_0417_)
  );
  NOR3_X1 _1746_ (
    .A1(_0393_),
    .A2(_0395_),
    .A3(_0417_),
    .ZN(_0000_[5])
  );
  NOR2_X1 _1747_ (
    .A1(baud_cnt[4]),
    .A2(_0397_),
    .ZN(_0418_)
  );
  NOR4_X1 _1748_ (
    .A1(_0393_),
    .A2(_0395_),
    .A3(_0398_),
    .A4(_0418_),
    .ZN(_0000_[4])
  );
  AOI21_X1 _1749_ (
    .A(baud_cnt[3]),
    .B1(baud_cnt[2]),
    .B2(_0396_),
    .ZN(_0419_)
  );
  NOR4_X1 _1750_ (
    .A1(_0393_),
    .A2(_0395_),
    .A3(_0397_),
    .A4(_0419_),
    .ZN(_0000_[3])
  );
  XNOR2_X1 _1751_ (
    .A(baud_cnt[2]),
    .B(_0396_),
    .ZN(_0420_)
  );
  NOR3_X1 _1752_ (
    .A1(_0393_),
    .A2(_0395_),
    .A3(_0420_),
    .ZN(_0000_[2])
  );
  NOR2_X1 _1753_ (
    .A1(baud_cnt[1]),
    .A2(baud_cnt[0]),
    .ZN(_0421_)
  );
  NOR4_X1 _1754_ (
    .A1(_0393_),
    .A2(_0395_),
    .A3(_0396_),
    .A4(_0421_),
    .ZN(_0000_[1])
  );
  OR3_X1 _1755_ (
    .A1(_0732_),
    .A2(_0393_),
    .A3(_0395_),
    .ZN(_0000_[0])
  );
  NAND2_X1 _1756_ (
    .A1(rx_sub[0]),
    .A2(rx_sub[1]),
    .ZN(_0422_)
  );
  NAND3_X1 _1757_ (
    .A1(rx_sub[0]),
    .A2(rx_sub[1]),
    .A3(rx_sub[2]),
    .ZN(_0423_)
  );
  NOR2_X1 _1758_ (
    .A1(rx_sub[3]),
    .A2(_0423_),
    .ZN(_0424_)
  );
  INV_X1 _1759_ (
    .A(_0424_),
    .ZN(_0425_)
  );
  NAND2_X1 _1760_ (
    .A1(baud_tick),
    .A2(_0424_),
    .ZN(_0426_)
  );
  NAND3_X1 _1761_ (
    .A1(rx_state[2]),
    .A2(baud_tick),
    .A3(_0424_),
    .ZN(_0427_)
  );
  NAND3_X1 _1762_ (
    .A1(rx_bit_idx[0]),
    .A2(rx_bit_idx[1]),
    .A3(rx_bit_idx[2]),
    .ZN(_0428_)
  );
  NAND2_X1 _1763_ (
    .A1(rx_state[1]),
    .A2(_0428_),
    .ZN(_0429_)
  );
  NAND4_X1 _1764_ (
    .A1(rx_sub[0]),
    .A2(rx_sub[1]),
    .A3(rx_sub[2]),
    .A4(rx_sub[3]),
    .ZN(_0430_)
  );
  OR2_X1 _1765_ (
    .A1(_0758_),
    .A2(_0430_),
    .ZN(_0431_)
  );
  OAI21_X1 _1766_ (
    .A(rx_state[1]),
    .B1(_0428_),
    .B2(_0431_),
    .ZN(_0432_)
  );
  OAI21_X1 _1767_ (
    .A(_0432_),
    .B1(_0427_),
    .B2(sin_s2),
    .ZN(_0004_)
  );
  NOR2_X1 _1768_ (
    .A1(sin_s2),
    .A2(_0758_),
    .ZN(_0433_)
  );
  AOI22_X1 _1769_ (
    .A1(rx_state[2]),
    .A2(_0426_),
    .B1(_0433_),
    .B2(rx_state[0]),
    .ZN(_0434_)
  );
  INV_X1 _1770_ (
    .A(_0434_),
    .ZN(_0005_)
  );
  NAND2_X1 _1771_ (
    .A1(baud_tick),
    .A2(_0803_),
    .ZN(_0435_)
  );
  NAND3_X1 _1772_ (
    .A1(tx_state[0]),
    .A2(baud_tick),
    .A3(_0803_),
    .ZN(_0436_)
  );
  NAND2_X1 _1773_ (
    .A1(tx_sub[0]),
    .A2(tx_sub[1]),
    .ZN(_0437_)
  );
  NOR3_X1 _1774_ (
    .A1(_0751_),
    .A2(_0759_),
    .A3(_0437_),
    .ZN(_0438_)
  );
  AND2_X1 _1775_ (
    .A1(baud_tick),
    .A2(_0438_),
    .ZN(_0439_)
  );
  NAND2_X1 _1776_ (
    .A1(baud_tick),
    .A2(_0438_),
    .ZN(_0440_)
  );
  OAI21_X1 _1777_ (
    .A(_0436_),
    .B1(_0439_),
    .B2(_0752_),
    .ZN(_0009_)
  );
  AOI22_X1 _1778_ (
    .A1(tx_state[0]),
    .A2(_0435_),
    .B1(_0439_),
    .B2(tx_state[3]),
    .ZN(_0441_)
  );
  INV_X1 _1779_ (
    .A(_0441_),
    .ZN(_0007_)
  );
  NAND2_X1 _1780_ (
    .A1(tx_state[2]),
    .A2(_0439_),
    .ZN(_0442_)
  );
  NAND3_X1 _1781_ (
    .A1(tx_bit_idx[0]),
    .A2(tx_bit_idx[1]),
    .A3(tx_bit_idx[2]),
    .ZN(_0443_)
  );
  OAI21_X1 _1782_ (
    .A(tx_state[1]),
    .B1(_0440_),
    .B2(_0443_),
    .ZN(_0444_)
  );
  NAND2_X1 _1783_ (
    .A1(_0442_),
    .A2(_0444_),
    .ZN(_0008_)
  );
  AOI22_X1 _1784_ (
    .A1(\rxf_mem[8] [7]),
    .A2(_0769_),
    .B1(_0776_),
    .B2(\rxf_mem[15] [7]),
    .ZN(_0445_)
  );
  AOI22_X1 _1785_ (
    .A1(\rxf_mem[10] [7]),
    .A2(_0768_),
    .B1(_0775_),
    .B2(\rxf_mem[9] [7]),
    .ZN(_0446_)
  );
  AOI222_X1 _1786_ (
    .A1(\rxf_mem[13] [7]),
    .A2(_0765_),
    .B1(_0774_),
    .B2(\rxf_mem[4] [7]),
    .C1(_0781_),
    .C2(\rxf_mem[14] [7]),
    .ZN(_0447_)
  );
  AOI222_X1 _1787_ (
    .A1(\rxf_mem[11] [7]),
    .A2(_0773_),
    .B1(_0778_),
    .B2(\rxf_mem[7] [7]),
    .C1(_0782_),
    .C2(\rxf_mem[2] [7]),
    .ZN(_0448_)
  );
  AOI222_X1 _1788_ (
    .A1(\rxf_mem[12] [7]),
    .A2(_0763_),
    .B1(_0771_),
    .B2(\rxf_mem[6] [7]),
    .C1(_0780_),
    .C2(\rxf_mem[3] [7]),
    .ZN(_0449_)
  );
  NAND3_X1 _1789_ (
    .A1(_0447_),
    .A2(_0448_),
    .A3(_0449_),
    .ZN(_0450_)
  );
  AOI21_X1 _1790_ (
    .A(lcr_r[7]),
    .B1(\rxf_mem[5] [7]),
    .B2(_0783_),
    .ZN(_0451_)
  );
  AOI22_X1 _1791_ (
    .A1(\rxf_mem[1] [7]),
    .A2(_0777_),
    .B1(_0779_),
    .B2(\rxf_mem[0] [7]),
    .ZN(_0452_)
  );
  NAND4_X1 _1792_ (
    .A1(_0445_),
    .A2(_0446_),
    .A3(_0451_),
    .A4(_0452_),
    .ZN(_0453_)
  );
  OAI221_X1 _1793_ (
    .A(_0792_),
    .B1(_0450_),
    .B2(_0453_),
    .C1(dll_r[7]),
    .C2(_0717_),
    .ZN(_0454_)
  );
  AOI221_X1 _1794_ (
    .A(_0812_),
    .B1(_0811_),
    .B2(DCDN),
    .C1(lcr_r[7]),
    .C2(_0809_),
    .ZN(_0455_)
  );
  INV_X1 _1795_ (
    .A(_0455_),
    .ZN(_0456_)
  );
  AOI221_X1 _1796_ (
    .A(_0456_),
    .B1(_0813_),
    .B2(scr_r[7]),
    .C1(dlm_r[7]),
    .C2(_0806_),
    .ZN(_0457_)
  );
  AOI21_X1 _1797_ (
    .A(_0761_),
    .B1(_0454_),
    .B2(_0457_),
    .ZN(PRDATA[7])
  );
  AOI21_X1 _1798_ (
    .A(baud_cnt[15]),
    .B1(baud_cnt[14]),
    .B2(_0407_),
    .ZN(_0458_)
  );
  NOR3_X1 _1799_ (
    .A1(_0393_),
    .A2(_0395_),
    .A3(_0458_),
    .ZN(_0000_[15])
  );
  NOR2_X1 _1800_ (
    .A1(_0709_),
    .A2(_0428_),
    .ZN(_0459_)
  );
  MUX2_X1 _1801_ (
    .A(_0459_),
    .B(rx_state[3]),
    .S(_0431_),
    .Z(_0006_)
  );
  OR2_X1 _1802_ (
    .A1(_0748_),
    .A2(_0443_),
    .ZN(_0460_)
  );
  AND2_X1 _1803_ (
    .A1(_0439_),
    .A2(_0460_),
    .ZN(_0461_)
  );
  AOI21_X1 _1804_ (
    .A(_0461_),
    .B1(_0440_),
    .B2(_0750_),
    .ZN(_0010_)
  );
  NOR2_X1 _1805_ (
    .A1(_0710_),
    .A2(_0431_),
    .ZN(_0002_)
  );
  OAI21_X1 _1806_ (
    .A(rx_state[0]),
    .B1(_0758_),
    .B2(sin_s2),
    .ZN(_0462_)
  );
  OAI221_X1 _1807_ (
    .A(_0462_),
    .B1(_0427_),
    .B2(_0754_),
    .C1(_0710_),
    .C2(_0431_),
    .ZN(_0003_)
  );
  NAND3_X1 _1808_ (
    .A1(PSEL),
    .A2(PENABLE),
    .A3(PWRITE),
    .ZN(_0463_)
  );
  NOR2_X1 _1809_ (
    .A1(lcr_r[7]),
    .A2(_0463_),
    .ZN(_0464_)
  );
  NAND2_X1 _1810_ (
    .A1(_0792_),
    .A2(_0464_),
    .ZN(_0465_)
  );
  AOI21_X1 _1811_ (
    .A(_0465_),
    .B1(_0801_),
    .B2(_0800_),
    .ZN(_0466_)
  );
  INV_X1 _1812_ (
    .A(_0466_),
    .ZN(_0467_)
  );
  NAND3_X1 _1813_ (
    .A1(txf_wptr[3]),
    .A2(RSTN),
    .A3(_0466_),
    .ZN(_0468_)
  );
  NAND4_X1 _1814_ (
    .A1(txf_wptr[2]),
    .A2(txf_wptr[3]),
    .A3(RSTN),
    .A4(_0466_),
    .ZN(_0469_)
  );
  NOR3_X1 _1815_ (
    .A1(txf_wptr[0]),
    .A2(txf_wptr[1]),
    .A3(_0469_),
    .ZN(_0470_)
  );
  MUX2_X1 _1816_ (
    .A(\txf_mem[12] [6]),
    .B(PWDATA[6]),
    .S(_0470_),
    .Z(_0014_)
  );
  MUX2_X1 _1817_ (
    .A(\txf_mem[12] [5]),
    .B(PWDATA[5]),
    .S(_0470_),
    .Z(_0015_)
  );
  MUX2_X1 _1818_ (
    .A(\txf_mem[12] [4]),
    .B(PWDATA[4]),
    .S(_0470_),
    .Z(_0016_)
  );
  MUX2_X1 _1819_ (
    .A(\txf_mem[12] [3]),
    .B(PWDATA[3]),
    .S(_0470_),
    .Z(_0017_)
  );
  MUX2_X1 _1820_ (
    .A(\txf_mem[12] [2]),
    .B(PWDATA[2]),
    .S(_0470_),
    .Z(_0018_)
  );
  MUX2_X1 _1821_ (
    .A(\txf_mem[12] [1]),
    .B(PWDATA[1]),
    .S(_0470_),
    .Z(_0019_)
  );
  MUX2_X1 _1822_ (
    .A(\txf_mem[12] [0]),
    .B(PWDATA[0]),
    .S(_0470_),
    .Z(_0020_)
  );
  NOR2_X1 _1823_ (
    .A1(rxf_wptr[2]),
    .A2(rxf_wptr[3]),
    .ZN(_0471_)
  );
  OR2_X1 _1824_ (
    .A1(_0870_),
    .A2(_0871_),
    .ZN(_0472_)
  );
  AND2_X1 _1825_ (
    .A1(rx_push),
    .A2(_0472_),
    .ZN(_0473_)
  );
  NAND2_X1 _1826_ (
    .A1(rxf_wptr[0]),
    .A2(_0473_),
    .ZN(_0474_)
  );
  NAND4_X1 _1827_ (
    .A1(rxf_wptr[0]),
    .A2(_0711_),
    .A3(RSTN),
    .A4(_0473_),
    .ZN(_0475_)
  );
  NOR3_X1 _1828_ (
    .A1(rxf_wptr[2]),
    .A2(rxf_wptr[3]),
    .A3(_0475_),
    .ZN(_0476_)
  );
  MUX2_X1 _1829_ (
    .A(\rxf_mem[1] [6]),
    .B(rx_shift[6]),
    .S(_0476_),
    .Z(_0021_)
  );
  MUX2_X1 _1830_ (
    .A(\rxf_mem[1] [5]),
    .B(rx_shift[5]),
    .S(_0476_),
    .Z(_0022_)
  );
  MUX2_X1 _1831_ (
    .A(\rxf_mem[1] [4]),
    .B(rx_shift[4]),
    .S(_0476_),
    .Z(_0023_)
  );
  MUX2_X1 _1832_ (
    .A(\rxf_mem[1] [3]),
    .B(rx_shift[3]),
    .S(_0476_),
    .Z(_0024_)
  );
  MUX2_X1 _1833_ (
    .A(\rxf_mem[1] [2]),
    .B(rx_shift[2]),
    .S(_0476_),
    .Z(_0025_)
  );
  MUX2_X1 _1834_ (
    .A(\rxf_mem[1] [1]),
    .B(rx_shift[1]),
    .S(_0476_),
    .Z(_0026_)
  );
  MUX2_X1 _1835_ (
    .A(\rxf_mem[1] [0]),
    .B(rx_shift[0]),
    .S(_0476_),
    .Z(_0027_)
  );
  NAND2_X1 _1836_ (
    .A1(_0722_),
    .A2(RSTN),
    .ZN(_0477_)
  );
  AND2_X1 _1837_ (
    .A1(txf_wptr[0]),
    .A2(txf_wptr[1]),
    .ZN(_0478_)
  );
  NAND2_X1 _1838_ (
    .A1(txf_wptr[0]),
    .A2(txf_wptr[1]),
    .ZN(_0479_)
  );
  NAND4_X1 _1839_ (
    .A1(txf_wptr[2]),
    .A2(_0722_),
    .A3(RSTN),
    .A4(_0466_),
    .ZN(_0480_)
  );
  NOR2_X1 _1840_ (
    .A1(_0479_),
    .A2(_0480_),
    .ZN(_0481_)
  );
  MUX2_X1 _1841_ (
    .A(\txf_mem[7] [6]),
    .B(PWDATA[6]),
    .S(_0481_),
    .Z(_0028_)
  );
  MUX2_X1 _1842_ (
    .A(\txf_mem[7] [5]),
    .B(PWDATA[5]),
    .S(_0481_),
    .Z(_0029_)
  );
  MUX2_X1 _1843_ (
    .A(\txf_mem[7] [4]),
    .B(PWDATA[4]),
    .S(_0481_),
    .Z(_0030_)
  );
  MUX2_X1 _1844_ (
    .A(\txf_mem[7] [3]),
    .B(PWDATA[3]),
    .S(_0481_),
    .Z(_0031_)
  );
  MUX2_X1 _1845_ (
    .A(\txf_mem[7] [2]),
    .B(PWDATA[2]),
    .S(_0481_),
    .Z(_0032_)
  );
  MUX2_X1 _1846_ (
    .A(\txf_mem[7] [1]),
    .B(PWDATA[1]),
    .S(_0481_),
    .Z(_0033_)
  );
  MUX2_X1 _1847_ (
    .A(\txf_mem[7] [0]),
    .B(PWDATA[0]),
    .S(_0481_),
    .Z(_0034_)
  );
  NOR3_X1 _1848_ (
    .A1(txf_wptr[2]),
    .A2(_0468_),
    .A3(_0479_),
    .ZN(_0482_)
  );
  MUX2_X1 _1849_ (
    .A(\txf_mem[11] [6]),
    .B(PWDATA[6]),
    .S(_0482_),
    .Z(_0035_)
  );
  MUX2_X1 _1850_ (
    .A(\txf_mem[11] [5]),
    .B(PWDATA[5]),
    .S(_0482_),
    .Z(_0036_)
  );
  MUX2_X1 _1851_ (
    .A(\txf_mem[11] [4]),
    .B(PWDATA[4]),
    .S(_0482_),
    .Z(_0037_)
  );
  MUX2_X1 _1852_ (
    .A(\txf_mem[11] [3]),
    .B(PWDATA[3]),
    .S(_0482_),
    .Z(_0038_)
  );
  MUX2_X1 _1853_ (
    .A(\txf_mem[11] [2]),
    .B(PWDATA[2]),
    .S(_0482_),
    .Z(_0039_)
  );
  MUX2_X1 _1854_ (
    .A(\txf_mem[11] [1]),
    .B(PWDATA[1]),
    .S(_0482_),
    .Z(_0040_)
  );
  MUX2_X1 _1855_ (
    .A(\txf_mem[11] [0]),
    .B(PWDATA[0]),
    .S(_0482_),
    .Z(_0041_)
  );
  AND3_X1 _1856_ (
    .A1(txf_wptr[2]),
    .A2(_0466_),
    .A3(_0478_),
    .ZN(_0483_)
  );
  NAND2_X1 _1857_ (
    .A1(txf_wptr[3]),
    .A2(_0483_),
    .ZN(_0484_)
  );
  XNOR2_X1 _1858_ (
    .A(_0722_),
    .B(_0483_),
    .ZN(_0042_)
  );
  AOI21_X1 _1859_ (
    .A(txf_wptr[2]),
    .B1(_0466_),
    .B2(_0478_),
    .ZN(_0485_)
  );
  NOR2_X1 _1860_ (
    .A1(_0483_),
    .A2(_0485_),
    .ZN(_0043_)
  );
  NAND2_X1 _1861_ (
    .A1(txf_wptr[0]),
    .A2(_0721_),
    .ZN(_0486_)
  );
  OR2_X1 _1862_ (
    .A1(txf_wptr[0]),
    .A2(_0721_),
    .ZN(_0487_)
  );
  NAND2_X1 _1863_ (
    .A1(_0486_),
    .A2(_0487_),
    .ZN(_0488_)
  );
  MUX2_X1 _1864_ (
    .A(txf_wptr[1]),
    .B(_0488_),
    .S(_0466_),
    .Z(_0044_)
  );
  MUX2_X1 _1865_ (
    .A(txf_wptr[0]),
    .B(_0913_[0]),
    .S(_0466_),
    .Z(_0045_)
  );
  OR3_X1 _1866_ (
    .A1(txf_wptr[2]),
    .A2(_0467_),
    .A3(_0477_),
    .ZN(_0489_)
  );
  OR4_X1 _1867_ (
    .A1(txf_wptr[2]),
    .A2(_0467_),
    .A3(_0477_),
    .A4(_0479_),
    .ZN(_0490_)
  );
  MUX2_X1 _1868_ (
    .A(PWDATA[6]),
    .B(\txf_mem[3] [6]),
    .S(_0490_),
    .Z(_0046_)
  );
  MUX2_X1 _1869_ (
    .A(PWDATA[5]),
    .B(\txf_mem[3] [5]),
    .S(_0490_),
    .Z(_0047_)
  );
  MUX2_X1 _1870_ (
    .A(PWDATA[4]),
    .B(\txf_mem[3] [4]),
    .S(_0490_),
    .Z(_0048_)
  );
  MUX2_X1 _1871_ (
    .A(PWDATA[3]),
    .B(\txf_mem[3] [3]),
    .S(_0490_),
    .Z(_0049_)
  );
  MUX2_X1 _1872_ (
    .A(PWDATA[2]),
    .B(\txf_mem[3] [2]),
    .S(_0490_),
    .Z(_0050_)
  );
  MUX2_X1 _1873_ (
    .A(PWDATA[1]),
    .B(\txf_mem[3] [1]),
    .S(_0490_),
    .Z(_0051_)
  );
  MUX2_X1 _1874_ (
    .A(PWDATA[0]),
    .B(\txf_mem[3] [0]),
    .S(_0490_),
    .Z(_0052_)
  );
  NOR2_X1 _1875_ (
    .A1(_0712_),
    .A2(rxf_wptr[3]),
    .ZN(_0491_)
  );
  NAND2_X1 _1876_ (
    .A1(rxf_wptr[2]),
    .A2(_0713_),
    .ZN(_0492_)
  );
  NAND2_X1 _1877_ (
    .A1(RSTN),
    .A2(_0473_),
    .ZN(_0493_)
  );
  OR3_X1 _1878_ (
    .A1(rxf_wptr[0]),
    .A2(rxf_wptr[1]),
    .A3(_0493_),
    .ZN(_0494_)
  );
  NOR2_X1 _1879_ (
    .A1(_0492_),
    .A2(_0494_),
    .ZN(_0495_)
  );
  MUX2_X1 _1880_ (
    .A(\rxf_mem[4] [6]),
    .B(rx_shift[6]),
    .S(_0495_),
    .Z(_0053_)
  );
  MUX2_X1 _1881_ (
    .A(\rxf_mem[4] [5]),
    .B(rx_shift[5]),
    .S(_0495_),
    .Z(_0054_)
  );
  MUX2_X1 _1882_ (
    .A(\rxf_mem[4] [4]),
    .B(rx_shift[4]),
    .S(_0495_),
    .Z(_0055_)
  );
  MUX2_X1 _1883_ (
    .A(\rxf_mem[4] [3]),
    .B(rx_shift[3]),
    .S(_0495_),
    .Z(_0056_)
  );
  MUX2_X1 _1884_ (
    .A(\rxf_mem[4] [2]),
    .B(rx_shift[2]),
    .S(_0495_),
    .Z(_0057_)
  );
  MUX2_X1 _1885_ (
    .A(\rxf_mem[4] [1]),
    .B(rx_shift[1]),
    .S(_0495_),
    .Z(_0058_)
  );
  MUX2_X1 _1886_ (
    .A(\rxf_mem[4] [0]),
    .B(rx_shift[0]),
    .S(_0495_),
    .Z(_0059_)
  );
  NOR3_X1 _1887_ (
    .A1(rxf_wptr[2]),
    .A2(rxf_wptr[3]),
    .A3(_0494_),
    .ZN(_0496_)
  );
  MUX2_X1 _1888_ (
    .A(\rxf_mem[0] [6]),
    .B(rx_shift[6]),
    .S(_0496_),
    .Z(_0060_)
  );
  MUX2_X1 _1889_ (
    .A(\rxf_mem[0] [5]),
    .B(rx_shift[5]),
    .S(_0496_),
    .Z(_0061_)
  );
  MUX2_X1 _1890_ (
    .A(\rxf_mem[0] [4]),
    .B(rx_shift[4]),
    .S(_0496_),
    .Z(_0062_)
  );
  MUX2_X1 _1891_ (
    .A(\rxf_mem[0] [3]),
    .B(rx_shift[3]),
    .S(_0496_),
    .Z(_0063_)
  );
  MUX2_X1 _1892_ (
    .A(\rxf_mem[0] [2]),
    .B(rx_shift[2]),
    .S(_0496_),
    .Z(_0064_)
  );
  MUX2_X1 _1893_ (
    .A(\rxf_mem[0] [1]),
    .B(rx_shift[1]),
    .S(_0496_),
    .Z(_0065_)
  );
  MUX2_X1 _1894_ (
    .A(\rxf_mem[0] [0]),
    .B(rx_shift[0]),
    .S(_0496_),
    .Z(_0066_)
  );
  NAND2_X1 _1895_ (
    .A1(_0748_),
    .A2(_0752_),
    .ZN(_0497_)
  );
  NOR2_X1 _1896_ (
    .A1(tx_state[3]),
    .A2(_0497_),
    .ZN(_0498_)
  );
  OR2_X1 _1897_ (
    .A1(tx_state[3]),
    .A2(_0497_),
    .ZN(_0499_)
  );
  NAND2_X1 _1898_ (
    .A1(_0749_),
    .A2(baud_tick),
    .ZN(_0500_)
  );
  OAI211_X1 _1899_ (
    .A(baud_tick),
    .B(_0499_),
    .C1(_0803_),
    .C2(_0749_),
    .ZN(_0501_)
  );
  AOI22_X1 _1900_ (
    .A1(_0749_),
    .A2(_0498_),
    .B1(_0500_),
    .B2(_0435_),
    .ZN(_0502_)
  );
  INV_X1 _1901_ (
    .A(_0502_),
    .ZN(_0503_)
  );
  AOI21_X1 _1902_ (
    .A(_0503_),
    .B1(_0499_),
    .B2(_0437_),
    .ZN(_0504_)
  );
  OR3_X1 _1903_ (
    .A1(tx_sub[2]),
    .A2(_0437_),
    .A3(_0501_),
    .ZN(_0505_)
  );
  OAI21_X1 _1904_ (
    .A(_0505_),
    .B1(_0504_),
    .B2(_0751_),
    .ZN(_0067_)
  );
  AOI21_X1 _1905_ (
    .A(tx_sub[1]),
    .B1(_0502_),
    .B2(tx_sub[0]),
    .ZN(_0506_)
  );
  NOR2_X1 _1906_ (
    .A1(_0504_),
    .A2(_0506_),
    .ZN(_0068_)
  );
  OAI22_X1 _1907_ (
    .A1(_0753_),
    .A2(_0501_),
    .B1(_0502_),
    .B2(_0705_),
    .ZN(_0069_)
  );
  NAND3_X1 _1908_ (
    .A1(tx_bit_idx[0]),
    .A2(_0461_),
    .A3(_0497_),
    .ZN(_0507_)
  );
  OR2_X1 _1909_ (
    .A1(_0744_),
    .A2(_0507_),
    .ZN(_0508_)
  );
  NOR2_X1 _1910_ (
    .A1(tx_state[1]),
    .A2(_0442_),
    .ZN(_0509_)
  );
  AOI21_X1 _1911_ (
    .A(_0509_),
    .B1(_0507_),
    .B2(_0744_),
    .ZN(_0510_)
  );
  AND2_X1 _1912_ (
    .A1(_0508_),
    .A2(_0510_),
    .ZN(_0070_)
  );
  OAI21_X1 _1913_ (
    .A(_0743_),
    .B1(_0748_),
    .B2(_0440_),
    .ZN(_0511_)
  );
  AND2_X1 _1914_ (
    .A1(_0507_),
    .A2(_0511_),
    .ZN(_0071_)
  );
  NOR2_X1 _1915_ (
    .A1(_0711_),
    .A2(_0474_),
    .ZN(_0512_)
  );
  AND2_X1 _1916_ (
    .A1(RSTN),
    .A2(_0512_),
    .ZN(_0513_)
  );
  NAND2_X1 _1917_ (
    .A1(_0471_),
    .A2(_0513_),
    .ZN(_0514_)
  );
  MUX2_X1 _1918_ (
    .A(rx_shift[6]),
    .B(\rxf_mem[3] [6]),
    .S(_0514_),
    .Z(_0072_)
  );
  MUX2_X1 _1919_ (
    .A(rx_shift[5]),
    .B(\rxf_mem[3] [5]),
    .S(_0514_),
    .Z(_0073_)
  );
  MUX2_X1 _1920_ (
    .A(rx_shift[4]),
    .B(\rxf_mem[3] [4]),
    .S(_0514_),
    .Z(_0074_)
  );
  MUX2_X1 _1921_ (
    .A(rx_shift[3]),
    .B(\rxf_mem[3] [3]),
    .S(_0514_),
    .Z(_0075_)
  );
  MUX2_X1 _1922_ (
    .A(rx_shift[2]),
    .B(\rxf_mem[3] [2]),
    .S(_0514_),
    .Z(_0076_)
  );
  MUX2_X1 _1923_ (
    .A(rx_shift[1]),
    .B(\rxf_mem[3] [1]),
    .S(_0514_),
    .Z(_0077_)
  );
  MUX2_X1 _1924_ (
    .A(rx_shift[0]),
    .B(\rxf_mem[3] [0]),
    .S(_0514_),
    .Z(_0078_)
  );
  AOI21_X1 _1925_ (
    .A(_0758_),
    .B1(_0430_),
    .B2(rx_state[1]),
    .ZN(_0515_)
  );
  INV_X1 _1926_ (
    .A(_0515_),
    .ZN(_0516_)
  );
  NOR4_X1 _1927_ (
    .A1(rx_state[3]),
    .A2(rx_state[2]),
    .A3(rx_state[0]),
    .A4(_0516_),
    .ZN(_0517_)
  );
  AND2_X1 _1928_ (
    .A1(rx_bit_idx[2]),
    .A2(_0517_),
    .ZN(_0518_)
  );
  NAND3_X1 _1929_ (
    .A1(_0755_),
    .A2(rx_bit_idx[1]),
    .A3(_0518_),
    .ZN(_0519_)
  );
  MUX2_X1 _1930_ (
    .A(sin_s2),
    .B(rx_shift[6]),
    .S(_0519_),
    .Z(_0079_)
  );
  NAND3_X1 _1931_ (
    .A1(rx_bit_idx[0]),
    .A2(_0756_),
    .A3(_0518_),
    .ZN(_0520_)
  );
  MUX2_X1 _1932_ (
    .A(sin_s2),
    .B(rx_shift[5]),
    .S(_0520_),
    .Z(_0080_)
  );
  NAND3_X1 _1933_ (
    .A1(_0755_),
    .A2(_0756_),
    .A3(_0518_),
    .ZN(_0521_)
  );
  MUX2_X1 _1934_ (
    .A(sin_s2),
    .B(rx_shift[4]),
    .S(_0521_),
    .Z(_0081_)
  );
  NAND2_X1 _1935_ (
    .A1(_0757_),
    .A2(_0517_),
    .ZN(_0522_)
  );
  NOR3_X1 _1936_ (
    .A1(_0755_),
    .A2(_0756_),
    .A3(_0522_),
    .ZN(_0523_)
  );
  MUX2_X1 _1937_ (
    .A(rx_shift[3]),
    .B(sin_s2),
    .S(_0523_),
    .Z(_0082_)
  );
  NOR3_X1 _1938_ (
    .A1(rx_bit_idx[0]),
    .A2(_0756_),
    .A3(_0522_),
    .ZN(_0524_)
  );
  MUX2_X1 _1939_ (
    .A(rx_shift[2]),
    .B(sin_s2),
    .S(_0524_),
    .Z(_0083_)
  );
  NOR3_X1 _1940_ (
    .A1(_0755_),
    .A2(rx_bit_idx[1]),
    .A3(_0522_),
    .ZN(_0525_)
  );
  MUX2_X1 _1941_ (
    .A(rx_shift[1]),
    .B(sin_s2),
    .S(_0525_),
    .Z(_0084_)
  );
  NOR3_X1 _1942_ (
    .A1(rx_bit_idx[0]),
    .A2(rx_bit_idx[1]),
    .A3(_0522_),
    .ZN(_0526_)
  );
  MUX2_X1 _1943_ (
    .A(rx_shift[0]),
    .B(sin_s2),
    .S(_0526_),
    .Z(_0085_)
  );
  NOR2_X1 _1944_ (
    .A1(rxf_wptr[2]),
    .A2(_0713_),
    .ZN(_0527_)
  );
  NAND2_X1 _1945_ (
    .A1(_0712_),
    .A2(rxf_wptr[3]),
    .ZN(_0528_)
  );
  NOR3_X1 _1946_ (
    .A1(rxf_wptr[0]),
    .A2(_0711_),
    .A3(_0493_),
    .ZN(_0529_)
  );
  NAND2_X1 _1947_ (
    .A1(_0527_),
    .A2(_0529_),
    .ZN(_0530_)
  );
  MUX2_X1 _1948_ (
    .A(rx_shift[6]),
    .B(\rxf_mem[10] [6]),
    .S(_0530_),
    .Z(_0086_)
  );
  MUX2_X1 _1949_ (
    .A(rx_shift[5]),
    .B(\rxf_mem[10] [5]),
    .S(_0530_),
    .Z(_0087_)
  );
  NAND2_X1 _1950_ (
    .A1(rxf_wptr[2]),
    .A2(_0512_),
    .ZN(_0531_)
  );
  XNOR2_X1 _1951_ (
    .A(rxf_wptr[3]),
    .B(_0531_),
    .ZN(_0088_)
  );
  XNOR2_X1 _1952_ (
    .A(_0712_),
    .B(_0512_),
    .ZN(_0089_)
  );
  XNOR2_X1 _1953_ (
    .A(rxf_wptr[1]),
    .B(_0474_),
    .ZN(_0090_)
  );
  MUX2_X1 _1954_ (
    .A(rxf_wptr[0]),
    .B(_0911_[0]),
    .S(_0473_),
    .Z(_0091_)
  );
  NOR2_X1 _1955_ (
    .A1(_0469_),
    .A2(_0486_),
    .ZN(_0532_)
  );
  MUX2_X1 _1956_ (
    .A(\txf_mem[13] [6]),
    .B(PWDATA[6]),
    .S(_0532_),
    .Z(_0092_)
  );
  MUX2_X1 _1957_ (
    .A(\txf_mem[13] [5]),
    .B(PWDATA[5]),
    .S(_0532_),
    .Z(_0093_)
  );
  MUX2_X1 _1958_ (
    .A(\txf_mem[13] [4]),
    .B(PWDATA[4]),
    .S(_0532_),
    .Z(_0094_)
  );
  MUX2_X1 _1959_ (
    .A(\txf_mem[13] [3]),
    .B(PWDATA[3]),
    .S(_0532_),
    .Z(_0095_)
  );
  MUX2_X1 _1960_ (
    .A(\txf_mem[13] [2]),
    .B(PWDATA[2]),
    .S(_0532_),
    .Z(_0096_)
  );
  MUX2_X1 _1961_ (
    .A(\txf_mem[13] [1]),
    .B(PWDATA[1]),
    .S(_0532_),
    .Z(_0097_)
  );
  MUX2_X1 _1962_ (
    .A(\txf_mem[13] [0]),
    .B(PWDATA[0]),
    .S(_0532_),
    .Z(_0098_)
  );
  MUX2_X1 _1963_ (
    .A(rx_shift[4]),
    .B(\rxf_mem[10] [4]),
    .S(_0530_),
    .Z(_0099_)
  );
  NOR2_X1 _1964_ (
    .A1(_0475_),
    .A2(_0528_),
    .ZN(_0533_)
  );
  MUX2_X1 _1965_ (
    .A(\rxf_mem[9] [6]),
    .B(rx_shift[6]),
    .S(_0533_),
    .Z(_0100_)
  );
  MUX2_X1 _1966_ (
    .A(\rxf_mem[9] [5]),
    .B(rx_shift[5]),
    .S(_0533_),
    .Z(_0101_)
  );
  MUX2_X1 _1967_ (
    .A(\rxf_mem[9] [4]),
    .B(rx_shift[4]),
    .S(_0533_),
    .Z(_0102_)
  );
  MUX2_X1 _1968_ (
    .A(\rxf_mem[9] [3]),
    .B(rx_shift[3]),
    .S(_0533_),
    .Z(_0103_)
  );
  MUX2_X1 _1969_ (
    .A(\rxf_mem[9] [2]),
    .B(rx_shift[2]),
    .S(_0533_),
    .Z(_0104_)
  );
  MUX2_X1 _1970_ (
    .A(\rxf_mem[9] [1]),
    .B(rx_shift[1]),
    .S(_0533_),
    .Z(_0105_)
  );
  MUX2_X1 _1971_ (
    .A(\rxf_mem[9] [0]),
    .B(rx_shift[0]),
    .S(_0533_),
    .Z(_0106_)
  );
  MUX2_X1 _1972_ (
    .A(rx_shift[3]),
    .B(\rxf_mem[10] [3]),
    .S(_0530_),
    .Z(_0107_)
  );
  OR4_X1 _1973_ (
    .A1(lcr_r[7]),
    .A2(_0761_),
    .A3(_0793_),
    .A4(_0873_),
    .ZN(_0534_)
  );
  OR2_X1 _1974_ (
    .A1(_0772_),
    .A2(_0534_),
    .ZN(_0535_)
  );
  OAI21_X1 _1975_ (
    .A(rxf_rptr[3]),
    .B1(_0716_),
    .B2(_0535_),
    .ZN(_0536_)
  );
  OAI21_X1 _1976_ (
    .A(_0536_),
    .B1(_0535_),
    .B2(_0770_),
    .ZN(_0108_)
  );
  XNOR2_X1 _1977_ (
    .A(rxf_rptr[2]),
    .B(_0535_),
    .ZN(_0109_)
  );
  NAND2_X1 _1978_ (
    .A1(_0764_),
    .A2(_0767_),
    .ZN(_0537_)
  );
  MUX2_X1 _1979_ (
    .A(_0537_),
    .B(rxf_rptr[1]),
    .S(_0534_),
    .Z(_0110_)
  );
  MUX2_X1 _1980_ (
    .A(_0910_[0]),
    .B(rxf_rptr[0]),
    .S(_0534_),
    .Z(_0111_)
  );
  NAND2_X1 _1981_ (
    .A1(_0491_),
    .A2(_0529_),
    .ZN(_0538_)
  );
  MUX2_X1 _1982_ (
    .A(rx_shift[6]),
    .B(\rxf_mem[6] [6]),
    .S(_0538_),
    .Z(_0112_)
  );
  MUX2_X1 _1983_ (
    .A(rx_shift[5]),
    .B(\rxf_mem[6] [5]),
    .S(_0538_),
    .Z(_0113_)
  );
  MUX2_X1 _1984_ (
    .A(rx_shift[4]),
    .B(\rxf_mem[6] [4]),
    .S(_0538_),
    .Z(_0114_)
  );
  MUX2_X1 _1985_ (
    .A(rx_shift[3]),
    .B(\rxf_mem[6] [3]),
    .S(_0538_),
    .Z(_0115_)
  );
  MUX2_X1 _1986_ (
    .A(rx_shift[2]),
    .B(\rxf_mem[6] [2]),
    .S(_0538_),
    .Z(_0116_)
  );
  MUX2_X1 _1987_ (
    .A(rx_shift[1]),
    .B(\rxf_mem[6] [1]),
    .S(_0538_),
    .Z(_0117_)
  );
  MUX2_X1 _1988_ (
    .A(rx_shift[0]),
    .B(\rxf_mem[6] [0]),
    .S(_0538_),
    .Z(_0118_)
  );
  MUX2_X1 _1989_ (
    .A(rx_shift[2]),
    .B(\rxf_mem[10] [2]),
    .S(_0530_),
    .Z(_0119_)
  );
  OR2_X1 _1990_ (
    .A1(txf_rptr[0]),
    .A2(txf_rptr[1]),
    .ZN(_0539_)
  );
  NAND2_X1 _1991_ (
    .A1(txf_rptr[3]),
    .A2(_0708_),
    .ZN(_0540_)
  );
  NOR2_X1 _1992_ (
    .A1(_0539_),
    .A2(_0540_),
    .ZN(_0541_)
  );
  NAND2_X1 _1993_ (
    .A1(txf_rptr[0]),
    .A2(txf_rptr[1]),
    .ZN(_0542_)
  );
  NOR2_X1 _1994_ (
    .A1(_0540_),
    .A2(_0542_),
    .ZN(_0543_)
  );
  NOR3_X1 _1995_ (
    .A1(txf_rptr[3]),
    .A2(txf_rptr[2]),
    .A3(_0542_),
    .ZN(_0544_)
  );
  NAND2_X1 _1996_ (
    .A1(txf_rptr[3]),
    .A2(txf_rptr[2]),
    .ZN(_0545_)
  );
  NAND2_X1 _1997_ (
    .A1(txf_rptr[0]),
    .A2(_0706_),
    .ZN(_0546_)
  );
  NOR2_X1 _1998_ (
    .A1(_0545_),
    .A2(_0546_),
    .ZN(_0547_)
  );
  NOR3_X1 _1999_ (
    .A1(txf_rptr[3]),
    .A2(txf_rptr[2]),
    .A3(_0539_),
    .ZN(_0548_)
  );
  OR2_X1 _2000_ (
    .A1(txf_rptr[0]),
    .A2(_0706_),
    .ZN(_0549_)
  );
  NOR3_X1 _2001_ (
    .A1(txf_rptr[3]),
    .A2(txf_rptr[2]),
    .A3(_0549_),
    .ZN(_0550_)
  );
  NAND2_X1 _2002_ (
    .A1(_0707_),
    .A2(txf_rptr[2]),
    .ZN(_0551_)
  );
  NOR2_X1 _2003_ (
    .A1(_0539_),
    .A2(_0551_),
    .ZN(_0552_)
  );
  NOR2_X1 _2004_ (
    .A1(_0546_),
    .A2(_0551_),
    .ZN(_0553_)
  );
  NOR2_X1 _2005_ (
    .A1(_0540_),
    .A2(_0546_),
    .ZN(_0554_)
  );
  NOR2_X1 _2006_ (
    .A1(_0542_),
    .A2(_0545_),
    .ZN(_0555_)
  );
  NOR2_X1 _2007_ (
    .A1(_0542_),
    .A2(_0551_),
    .ZN(_0556_)
  );
  NOR2_X1 _2008_ (
    .A1(_0540_),
    .A2(_0549_),
    .ZN(_0557_)
  );
  NOR2_X1 _2009_ (
    .A1(_0549_),
    .A2(_0551_),
    .ZN(_0558_)
  );
  NOR3_X1 _2010_ (
    .A1(txf_rptr[3]),
    .A2(txf_rptr[2]),
    .A3(_0546_),
    .ZN(_0559_)
  );
  NOR2_X1 _2011_ (
    .A1(_0539_),
    .A2(_0545_),
    .ZN(_0560_)
  );
  NOR2_X1 _2012_ (
    .A1(_0545_),
    .A2(_0549_),
    .ZN(_0561_)
  );
  AOI222_X1 _2013_ (
    .A1(\txf_mem[13] [6]),
    .A2(_0547_),
    .B1(_0554_),
    .B2(\txf_mem[9] [6]),
    .C1(_0560_),
    .C2(\txf_mem[12] [6]),
    .ZN(_0562_)
  );
  AOI222_X1 _2014_ (
    .A1(\txf_mem[8] [6]),
    .A2(_0541_),
    .B1(_0543_),
    .B2(\txf_mem[11] [6]),
    .C1(_0558_),
    .C2(\txf_mem[6] [6]),
    .ZN(_0563_)
  );
  AOI22_X1 _2015_ (
    .A1(\txf_mem[3] [6]),
    .A2(_0544_),
    .B1(_0556_),
    .B2(\txf_mem[7] [6]),
    .ZN(_0564_)
  );
  AOI222_X1 _2016_ (
    .A1(\txf_mem[0] [6]),
    .A2(_0548_),
    .B1(_0553_),
    .B2(\txf_mem[5] [6]),
    .C1(_0557_),
    .C2(\txf_mem[10] [6]),
    .ZN(_0565_)
  );
  AOI222_X1 _2017_ (
    .A1(\txf_mem[2] [6]),
    .A2(_0550_),
    .B1(_0555_),
    .B2(\txf_mem[15] [6]),
    .C1(_0559_),
    .C2(\txf_mem[1] [6]),
    .ZN(_0566_)
  );
  NAND2_X1 _2018_ (
    .A1(_0565_),
    .A2(_0566_),
    .ZN(_0567_)
  );
  AOI221_X1 _2019_ (
    .A(_0567_),
    .B1(_0552_),
    .B2(\txf_mem[4] [6]),
    .C1(\txf_mem[14] [6]),
    .C2(_0561_),
    .ZN(_0568_)
  );
  NAND4_X1 _2020_ (
    .A1(_0562_),
    .A2(_0563_),
    .A3(_0564_),
    .A4(_0568_),
    .ZN(_0569_)
  );
  MUX2_X1 _2021_ (
    .A(_0569_),
    .B(tx_shift[6]),
    .S(_0436_),
    .Z(_0120_)
  );
  AOI22_X1 _2022_ (
    .A1(\txf_mem[13] [5]),
    .A2(_0547_),
    .B1(_0553_),
    .B2(\txf_mem[5] [5]),
    .ZN(_0570_)
  );
  AOI222_X1 _2023_ (
    .A1(\txf_mem[12] [5]),
    .A2(_0560_),
    .B1(_0561_),
    .B2(\txf_mem[14] [5]),
    .C1(\txf_mem[4] [5]),
    .C2(_0552_),
    .ZN(_0571_)
  );
  AOI22_X1 _2024_ (
    .A1(\txf_mem[8] [5]),
    .A2(_0541_),
    .B1(_0548_),
    .B2(\txf_mem[0] [5]),
    .ZN(_0572_)
  );
  AOI222_X1 _2025_ (
    .A1(\txf_mem[9] [5]),
    .A2(_0554_),
    .B1(_0556_),
    .B2(\txf_mem[7] [5]),
    .C1(_0559_),
    .C2(\txf_mem[1] [5]),
    .ZN(_0573_)
  );
  NAND3_X1 _2026_ (
    .A1(_0571_),
    .A2(_0572_),
    .A3(_0573_),
    .ZN(_0574_)
  );
  AOI222_X1 _2027_ (
    .A1(\txf_mem[11] [5]),
    .A2(_0543_),
    .B1(_0555_),
    .B2(\txf_mem[15] [5]),
    .C1(_0557_),
    .C2(\txf_mem[10] [5]),
    .ZN(_0575_)
  );
  AOI222_X1 _2028_ (
    .A1(\txf_mem[3] [5]),
    .A2(_0544_),
    .B1(_0550_),
    .B2(\txf_mem[2] [5]),
    .C1(_0558_),
    .C2(\txf_mem[6] [5]),
    .ZN(_0576_)
  );
  NAND3_X1 _2029_ (
    .A1(_0570_),
    .A2(_0575_),
    .A3(_0576_),
    .ZN(_0577_)
  );
  NOR3_X1 _2030_ (
    .A1(_0436_),
    .A2(_0574_),
    .A3(_0577_),
    .ZN(_0578_)
  );
  AOI21_X1 _2031_ (
    .A(_0578_),
    .B1(_0436_),
    .B2(_0746_),
    .ZN(_0121_)
  );
  AOI222_X1 _2032_ (
    .A1(\txf_mem[4] [4]),
    .A2(_0552_),
    .B1(_0559_),
    .B2(\txf_mem[1] [4]),
    .C1(_0554_),
    .C2(\txf_mem[9] [4]),
    .ZN(_0579_)
  );
  AOI222_X1 _2033_ (
    .A1(\txf_mem[8] [4]),
    .A2(_0541_),
    .B1(_0548_),
    .B2(\txf_mem[0] [4]),
    .C1(_0558_),
    .C2(\txf_mem[6] [4]),
    .ZN(_0580_)
  );
  NAND2_X1 _2034_ (
    .A1(_0579_),
    .A2(_0580_),
    .ZN(_0581_)
  );
  AOI221_X1 _2035_ (
    .A(_0581_),
    .B1(_0560_),
    .B2(\txf_mem[12] [4]),
    .C1(\txf_mem[3] [4]),
    .C2(_0544_),
    .ZN(_0582_)
  );
  AOI222_X1 _2036_ (
    .A1(\txf_mem[13] [4]),
    .A2(_0547_),
    .B1(_0553_),
    .B2(\txf_mem[5] [4]),
    .C1(_0557_),
    .C2(\txf_mem[10] [4]),
    .ZN(_0583_)
  );
  AOI22_X1 _2037_ (
    .A1(\txf_mem[11] [4]),
    .A2(_0543_),
    .B1(_0550_),
    .B2(\txf_mem[2] [4]),
    .ZN(_0584_)
  );
  AOI222_X1 _2038_ (
    .A1(\txf_mem[15] [4]),
    .A2(_0555_),
    .B1(_0556_),
    .B2(\txf_mem[7] [4]),
    .C1(\txf_mem[14] [4]),
    .C2(_0561_),
    .ZN(_0585_)
  );
  NAND4_X1 _2039_ (
    .A1(_0582_),
    .A2(_0583_),
    .A3(_0584_),
    .A4(_0585_),
    .ZN(_0586_)
  );
  MUX2_X1 _2040_ (
    .A(_0586_),
    .B(tx_shift[4]),
    .S(_0436_),
    .Z(_0122_)
  );
  AOI222_X1 _2041_ (
    .A1(\txf_mem[8] [3]),
    .A2(_0541_),
    .B1(_0555_),
    .B2(\txf_mem[15] [3]),
    .C1(\txf_mem[10] [3]),
    .C2(_0557_),
    .ZN(_0587_)
  );
  AOI22_X1 _2042_ (
    .A1(\txf_mem[13] [3]),
    .A2(_0547_),
    .B1(_0556_),
    .B2(\txf_mem[7] [3]),
    .ZN(_0588_)
  );
  AOI222_X1 _2043_ (
    .A1(\txf_mem[0] [3]),
    .A2(_0548_),
    .B1(_0550_),
    .B2(\txf_mem[2] [3]),
    .C1(_0552_),
    .C2(\txf_mem[4] [3]),
    .ZN(_0589_)
  );
  AOI22_X1 _2044_ (
    .A1(\txf_mem[1] [3]),
    .A2(_0559_),
    .B1(_0560_),
    .B2(\txf_mem[12] [3]),
    .ZN(_0590_)
  );
  AND4_X1 _2045_ (
    .A1(_0587_),
    .A2(_0588_),
    .A3(_0589_),
    .A4(_0590_),
    .ZN(_0591_)
  );
  AOI222_X1 _2046_ (
    .A1(\txf_mem[11] [3]),
    .A2(_0543_),
    .B1(_0544_),
    .B2(\txf_mem[3] [3]),
    .C1(_0554_),
    .C2(\txf_mem[9] [3]),
    .ZN(_0592_)
  );
  AOI222_X1 _2047_ (
    .A1(\txf_mem[5] [3]),
    .A2(_0553_),
    .B1(_0558_),
    .B2(\txf_mem[6] [3]),
    .C1(\txf_mem[14] [3]),
    .C2(_0561_),
    .ZN(_0593_)
  );
  NAND3_X1 _2048_ (
    .A1(_0591_),
    .A2(_0592_),
    .A3(_0593_),
    .ZN(_0594_)
  );
  MUX2_X1 _2049_ (
    .A(_0594_),
    .B(tx_shift[3]),
    .S(_0436_),
    .Z(_0123_)
  );
  AOI222_X1 _2050_ (
    .A1(\txf_mem[8] [2]),
    .A2(_0541_),
    .B1(_0548_),
    .B2(\txf_mem[0] [2]),
    .C1(\txf_mem[9] [2]),
    .C2(_0554_),
    .ZN(_0595_)
  );
  AOI222_X1 _2051_ (
    .A1(\txf_mem[5] [2]),
    .A2(_0553_),
    .B1(_0555_),
    .B2(\txf_mem[15] [2]),
    .C1(\txf_mem[1] [2]),
    .C2(_0559_),
    .ZN(_0596_)
  );
  AOI22_X1 _2052_ (
    .A1(\txf_mem[11] [2]),
    .A2(_0543_),
    .B1(_0558_),
    .B2(\txf_mem[6] [2]),
    .ZN(_0597_)
  );
  AOI222_X1 _2053_ (
    .A1(\txf_mem[3] [2]),
    .A2(_0544_),
    .B1(_0550_),
    .B2(\txf_mem[2] [2]),
    .C1(_0556_),
    .C2(\txf_mem[7] [2]),
    .ZN(_0598_)
  );
  AOI222_X1 _2054_ (
    .A1(\txf_mem[13] [2]),
    .A2(_0547_),
    .B1(_0560_),
    .B2(\txf_mem[12] [2]),
    .C1(_0552_),
    .C2(\txf_mem[4] [2]),
    .ZN(_0599_)
  );
  NAND2_X1 _2055_ (
    .A1(_0598_),
    .A2(_0599_),
    .ZN(_0600_)
  );
  AOI221_X1 _2056_ (
    .A(_0600_),
    .B1(_0557_),
    .B2(\txf_mem[10] [2]),
    .C1(\txf_mem[14] [2]),
    .C2(_0561_),
    .ZN(_0601_)
  );
  NAND4_X1 _2057_ (
    .A1(_0595_),
    .A2(_0596_),
    .A3(_0597_),
    .A4(_0601_),
    .ZN(_0602_)
  );
  MUX2_X1 _2058_ (
    .A(_0602_),
    .B(tx_shift[2]),
    .S(_0436_),
    .Z(_0124_)
  );
  AOI22_X1 _2059_ (
    .A1(\txf_mem[4] [1]),
    .A2(_0552_),
    .B1(_0561_),
    .B2(\txf_mem[14] [1]),
    .ZN(_0603_)
  );
  AOI22_X1 _2060_ (
    .A1(\txf_mem[10] [1]),
    .A2(_0557_),
    .B1(_0560_),
    .B2(\txf_mem[12] [1]),
    .ZN(_0604_)
  );
  AOI22_X1 _2061_ (
    .A1(\txf_mem[8] [1]),
    .A2(_0541_),
    .B1(_0558_),
    .B2(\txf_mem[6] [1]),
    .ZN(_0605_)
  );
  AOI22_X1 _2062_ (
    .A1(\txf_mem[11] [1]),
    .A2(_0543_),
    .B1(_0553_),
    .B2(\txf_mem[5] [1]),
    .ZN(_0606_)
  );
  NAND4_X1 _2063_ (
    .A1(_0603_),
    .A2(_0604_),
    .A3(_0605_),
    .A4(_0606_),
    .ZN(_0607_)
  );
  AOI22_X1 _2064_ (
    .A1(\txf_mem[13] [1]),
    .A2(_0547_),
    .B1(_0550_),
    .B2(\txf_mem[2] [1]),
    .ZN(_0608_)
  );
  AOI22_X1 _2065_ (
    .A1(\txf_mem[15] [1]),
    .A2(_0555_),
    .B1(_0559_),
    .B2(\txf_mem[1] [1]),
    .ZN(_0609_)
  );
  AOI22_X1 _2066_ (
    .A1(\txf_mem[0] [1]),
    .A2(_0548_),
    .B1(_0554_),
    .B2(\txf_mem[9] [1]),
    .ZN(_0610_)
  );
  AOI22_X1 _2067_ (
    .A1(\txf_mem[3] [1]),
    .A2(_0544_),
    .B1(_0556_),
    .B2(\txf_mem[7] [1]),
    .ZN(_0611_)
  );
  NAND4_X1 _2068_ (
    .A1(_0608_),
    .A2(_0609_),
    .A3(_0610_),
    .A4(_0611_),
    .ZN(_0612_)
  );
  NOR3_X1 _2069_ (
    .A1(_0436_),
    .A2(_0607_),
    .A3(_0612_),
    .ZN(_0613_)
  );
  AOI21_X1 _2070_ (
    .A(_0613_),
    .B1(_0436_),
    .B2(_0742_),
    .ZN(_0125_)
  );
  AOI222_X1 _2071_ (
    .A1(\txf_mem[8] [0]),
    .A2(_0541_),
    .B1(_0544_),
    .B2(\txf_mem[3] [0]),
    .C1(\txf_mem[2] [0]),
    .C2(_0550_),
    .ZN(_0614_)
  );
  AOI222_X1 _2072_ (
    .A1(\txf_mem[11] [0]),
    .A2(_0543_),
    .B1(_0555_),
    .B2(\txf_mem[15] [0]),
    .C1(_0558_),
    .C2(\txf_mem[6] [0]),
    .ZN(_0615_)
  );
  AOI22_X1 _2073_ (
    .A1(\txf_mem[13] [0]),
    .A2(_0547_),
    .B1(_0552_),
    .B2(\txf_mem[4] [0]),
    .ZN(_0616_)
  );
  AOI222_X1 _2074_ (
    .A1(\txf_mem[9] [0]),
    .A2(_0554_),
    .B1(_0557_),
    .B2(\txf_mem[10] [0]),
    .C1(_0561_),
    .C2(\txf_mem[14] [0]),
    .ZN(_0617_)
  );
  AOI222_X1 _2075_ (
    .A1(\txf_mem[5] [0]),
    .A2(_0553_),
    .B1(_0560_),
    .B2(\txf_mem[12] [0]),
    .C1(_0556_),
    .C2(\txf_mem[7] [0]),
    .ZN(_0618_)
  );
  NAND2_X1 _2076_ (
    .A1(_0617_),
    .A2(_0618_),
    .ZN(_0619_)
  );
  AOI221_X1 _2077_ (
    .A(_0619_),
    .B1(_0559_),
    .B2(\txf_mem[1] [0]),
    .C1(\txf_mem[0] [0]),
    .C2(_0548_),
    .ZN(_0620_)
  );
  NAND4_X1 _2078_ (
    .A1(_0614_),
    .A2(_0615_),
    .A3(_0616_),
    .A4(_0620_),
    .ZN(_0621_)
  );
  MUX2_X1 _2079_ (
    .A(_0621_),
    .B(tx_shift[0]),
    .S(_0436_),
    .Z(_0126_)
  );
  NOR3_X1 _2080_ (
    .A1(PADDR[2]),
    .A2(_0808_),
    .A3(_0463_),
    .ZN(_0622_)
  );
  MUX2_X1 _2081_ (
    .A(lcr_r[7]),
    .B(PWDATA[7]),
    .S(_0622_),
    .Z(_0127_)
  );
  MUX2_X1 _2082_ (
    .A(rx_shift[1]),
    .B(\rxf_mem[10] [1]),
    .S(_0530_),
    .Z(_0128_)
  );
  OAI21_X1 _2083_ (
    .A(rx_state[2]),
    .B1(sin_s2),
    .B2(_0425_),
    .ZN(_0623_)
  );
  NAND2_X1 _2084_ (
    .A1(_0515_),
    .A2(_0623_),
    .ZN(_0624_)
  );
  NOR2_X1 _2085_ (
    .A1(rx_state[1]),
    .A2(rx_state[2]),
    .ZN(_0625_)
  );
  NOR3_X1 _2086_ (
    .A1(_0459_),
    .A2(_0624_),
    .A3(_0625_),
    .ZN(_0626_)
  );
  OR2_X1 _2087_ (
    .A1(_0429_),
    .A2(_0624_),
    .ZN(_0627_)
  );
  XNOR2_X1 _2088_ (
    .A(rx_bit_idx[0]),
    .B(rx_bit_idx[1]),
    .ZN(_0628_)
  );
  OAI22_X1 _2089_ (
    .A1(_0756_),
    .A2(_0626_),
    .B1(_0627_),
    .B2(_0628_),
    .ZN(_0129_)
  );
  OR2_X1 _2090_ (
    .A1(rx_bit_idx[0]),
    .A2(_0627_),
    .ZN(_0629_)
  );
  OAI21_X1 _2091_ (
    .A(_0629_),
    .B1(_0626_),
    .B2(_0755_),
    .ZN(_0130_)
  );
  MUX2_X1 _2092_ (
    .A(rx_shift[0]),
    .B(\rxf_mem[10] [0]),
    .S(_0530_),
    .Z(_0131_)
  );
  NOR4_X1 _2093_ (
    .A1(txf_wptr[0]),
    .A2(txf_wptr[1]),
    .A3(txf_wptr[2]),
    .A4(_0468_),
    .ZN(_0630_)
  );
  MUX2_X1 _2094_ (
    .A(\txf_mem[8] [6]),
    .B(PWDATA[6]),
    .S(_0630_),
    .Z(_0132_)
  );
  MUX2_X1 _2095_ (
    .A(\txf_mem[8] [5]),
    .B(PWDATA[5]),
    .S(_0630_),
    .Z(_0133_)
  );
  MUX2_X1 _2096_ (
    .A(\txf_mem[8] [4]),
    .B(PWDATA[4]),
    .S(_0630_),
    .Z(_0134_)
  );
  MUX2_X1 _2097_ (
    .A(\txf_mem[8] [3]),
    .B(PWDATA[3]),
    .S(_0630_),
    .Z(_0135_)
  );
  NOR3_X1 _2098_ (
    .A1(_0720_),
    .A2(_0808_),
    .A3(_0463_),
    .ZN(_0631_)
  );
  MUX2_X1 _2099_ (
    .A(scr_r[7]),
    .B(PWDATA[7]),
    .S(_0631_),
    .Z(_0136_)
  );
  NOR3_X1 _2100_ (
    .A1(txf_wptr[2]),
    .A2(_0468_),
    .A3(_0486_),
    .ZN(_0632_)
  );
  MUX2_X1 _2101_ (
    .A(\txf_mem[9] [7]),
    .B(PWDATA[7]),
    .S(_0632_),
    .Z(_0137_)
  );
  NOR2_X1 _2102_ (
    .A1(_0480_),
    .A2(_0487_),
    .ZN(_0633_)
  );
  MUX2_X1 _2103_ (
    .A(\txf_mem[6] [7]),
    .B(PWDATA[7]),
    .S(_0633_),
    .Z(_0138_)
  );
  MUX2_X1 _2104_ (
    .A(\txf_mem[8] [2]),
    .B(PWDATA[2]),
    .S(_0630_),
    .Z(_0139_)
  );
  MUX2_X1 _2105_ (
    .A(\txf_mem[8] [1]),
    .B(PWDATA[1]),
    .S(_0630_),
    .Z(_0140_)
  );
  NOR2_X1 _2106_ (
    .A1(_0494_),
    .A2(_0528_),
    .ZN(_0634_)
  );
  MUX2_X1 _2107_ (
    .A(\rxf_mem[8] [7]),
    .B(rx_shift[7]),
    .S(_0634_),
    .Z(_0141_)
  );
  MUX2_X1 _2108_ (
    .A(\txf_mem[8] [0]),
    .B(PWDATA[0]),
    .S(_0630_),
    .Z(_0142_)
  );
  NOR2_X1 _2109_ (
    .A1(_0480_),
    .A2(_0486_),
    .ZN(_0635_)
  );
  MUX2_X1 _2110_ (
    .A(\txf_mem[5] [7]),
    .B(PWDATA[7]),
    .S(_0635_),
    .Z(_0143_)
  );
  NAND2_X1 _2111_ (
    .A1(_0513_),
    .A2(_0527_),
    .ZN(_0636_)
  );
  MUX2_X1 _2112_ (
    .A(rx_shift[6]),
    .B(\rxf_mem[11] [6]),
    .S(_0636_),
    .Z(_0144_)
  );
  MUX2_X1 _2113_ (
    .A(rx_shift[5]),
    .B(\rxf_mem[11] [5]),
    .S(_0636_),
    .Z(_0145_)
  );
  MUX2_X1 _2114_ (
    .A(rx_shift[4]),
    .B(\rxf_mem[11] [4]),
    .S(_0636_),
    .Z(_0146_)
  );
  MUX2_X1 _2115_ (
    .A(rx_shift[3]),
    .B(\rxf_mem[11] [3]),
    .S(_0636_),
    .Z(_0147_)
  );
  MUX2_X1 _2116_ (
    .A(rx_shift[2]),
    .B(\rxf_mem[11] [2]),
    .S(_0636_),
    .Z(_0148_)
  );
  MUX2_X1 _2117_ (
    .A(rx_shift[1]),
    .B(\rxf_mem[11] [1]),
    .S(_0636_),
    .Z(_0149_)
  );
  MUX2_X1 _2118_ (
    .A(rx_shift[0]),
    .B(\rxf_mem[11] [0]),
    .S(_0636_),
    .Z(_0150_)
  );
  NOR2_X1 _2119_ (
    .A1(_0487_),
    .A2(_0489_),
    .ZN(_0637_)
  );
  MUX2_X1 _2120_ (
    .A(\txf_mem[2] [6]),
    .B(PWDATA[6]),
    .S(_0637_),
    .Z(_0151_)
  );
  NAND2_X1 _2121_ (
    .A1(rxf_wptr[2]),
    .A2(rxf_wptr[3]),
    .ZN(_0638_)
  );
  NOR2_X1 _2122_ (
    .A1(_0475_),
    .A2(_0638_),
    .ZN(_0639_)
  );
  MUX2_X1 _2123_ (
    .A(\rxf_mem[13] [6]),
    .B(rx_shift[6]),
    .S(_0639_),
    .Z(_0152_)
  );
  MUX2_X1 _2124_ (
    .A(\rxf_mem[13] [5]),
    .B(rx_shift[5]),
    .S(_0639_),
    .Z(_0153_)
  );
  MUX2_X1 _2125_ (
    .A(\rxf_mem[13] [4]),
    .B(rx_shift[4]),
    .S(_0639_),
    .Z(_0154_)
  );
  MUX2_X1 _2126_ (
    .A(\rxf_mem[13] [3]),
    .B(rx_shift[3]),
    .S(_0639_),
    .Z(_0155_)
  );
  MUX2_X1 _2127_ (
    .A(\rxf_mem[13] [2]),
    .B(rx_shift[2]),
    .S(_0639_),
    .Z(_0156_)
  );
  NAND4_X1 _2128_ (
    .A1(PSEL),
    .A2(PENABLE),
    .A3(PWRITE),
    .A4(_0840_),
    .ZN(_0640_)
  );
  MUX2_X1 _2129_ (
    .A(PWDATA[4]),
    .B(mcr_r[4]),
    .S(_0640_),
    .Z(_0157_)
  );
  MUX2_X1 _2130_ (
    .A(\rxf_mem[13] [1]),
    .B(rx_shift[1]),
    .S(_0639_),
    .Z(_0158_)
  );
  MUX2_X1 _2131_ (
    .A(\rxf_mem[13] [0]),
    .B(rx_shift[0]),
    .S(_0639_),
    .Z(_0159_)
  );
  MUX2_X1 _2132_ (
    .A(\txf_mem[2] [5]),
    .B(PWDATA[5]),
    .S(_0637_),
    .Z(_0160_)
  );
  NOR3_X1 _2133_ (
    .A1(txf_wptr[2]),
    .A2(_0468_),
    .A3(_0487_),
    .ZN(_0641_)
  );
  MUX2_X1 _2134_ (
    .A(\txf_mem[10] [7]),
    .B(PWDATA[7]),
    .S(_0641_),
    .Z(_0161_)
  );
  NAND2_X1 _2135_ (
    .A1(_0710_),
    .A2(_0625_),
    .ZN(_0642_)
  );
  AOI21_X1 _2136_ (
    .A(_0758_),
    .B1(rx_state[0]),
    .B2(sin_s2),
    .ZN(_0643_)
  );
  AND4_X1 _2137_ (
    .A1(rx_sub[0]),
    .A2(rx_sub[1]),
    .A3(_0642_),
    .A4(_0643_),
    .ZN(_0644_)
  );
  NOR2_X1 _2138_ (
    .A1(rx_sub[2]),
    .A2(_0644_),
    .ZN(_0645_)
  );
  OAI21_X1 _2139_ (
    .A(_0643_),
    .B1(_0642_),
    .B2(rx_state[0]),
    .ZN(_0646_)
  );
  INV_X1 _2140_ (
    .A(_0646_),
    .ZN(_0647_)
  );
  AOI21_X1 _2141_ (
    .A(_0646_),
    .B1(_0642_),
    .B2(_0422_),
    .ZN(_0648_)
  );
  AOI21_X1 _2142_ (
    .A(_0645_),
    .B1(_0648_),
    .B2(rx_sub[2]),
    .ZN(_0162_)
  );
  AOI21_X1 _2143_ (
    .A(rx_sub[1]),
    .B1(_0647_),
    .B2(rx_sub[0]),
    .ZN(_0649_)
  );
  NOR2_X1 _2144_ (
    .A1(_0648_),
    .A2(_0649_),
    .ZN(_0163_)
  );
  NAND3_X1 _2145_ (
    .A1(_0011_),
    .A2(_0642_),
    .A3(_0643_),
    .ZN(_0650_)
  );
  OAI21_X1 _2146_ (
    .A(_0650_),
    .B1(_0647_),
    .B2(_0704_),
    .ZN(_0164_)
  );
  NOR2_X1 _2147_ (
    .A1(_0807_),
    .A2(_0463_),
    .ZN(_0651_)
  );
  MUX2_X1 _2148_ (
    .A(dlm_r[7]),
    .B(PWDATA[7]),
    .S(_0651_),
    .Z(_0165_)
  );
  MUX2_X1 _2149_ (
    .A(\txf_mem[2] [4]),
    .B(PWDATA[4]),
    .S(_0637_),
    .Z(_0166_)
  );
  MUX2_X1 _2150_ (
    .A(\txf_mem[2] [3]),
    .B(PWDATA[3]),
    .S(_0637_),
    .Z(_0167_)
  );
  NAND3_X1 _2151_ (
    .A1(txf_wptr[3]),
    .A2(RSTN),
    .A3(_0483_),
    .ZN(_0652_)
  );
  MUX2_X1 _2152_ (
    .A(PWDATA[7]),
    .B(\txf_mem[15] [7]),
    .S(_0652_),
    .Z(_0168_)
  );
  MUX2_X1 _2153_ (
    .A(\txf_mem[2] [2]),
    .B(PWDATA[2]),
    .S(_0637_),
    .Z(_0169_)
  );
  NAND2_X1 _2154_ (
    .A1(_0491_),
    .A2(_0513_),
    .ZN(_0653_)
  );
  MUX2_X1 _2155_ (
    .A(rx_shift[7]),
    .B(\rxf_mem[7] [7]),
    .S(_0653_),
    .Z(_0170_)
  );
  MUX2_X1 _2156_ (
    .A(\txf_mem[2] [1]),
    .B(PWDATA[1]),
    .S(_0637_),
    .Z(_0171_)
  );
  NOR3_X1 _2157_ (
    .A1(_0717_),
    .A2(_0793_),
    .A3(_0463_),
    .ZN(_0654_)
  );
  MUX2_X1 _2158_ (
    .A(dll_r[7]),
    .B(PWDATA[7]),
    .S(_0654_),
    .Z(_0172_)
  );
  NOR2_X1 _2159_ (
    .A1(_0486_),
    .A2(_0489_),
    .ZN(_0655_)
  );
  MUX2_X1 _2160_ (
    .A(\txf_mem[1] [6]),
    .B(PWDATA[6]),
    .S(_0655_),
    .Z(_0173_)
  );
  MUX2_X1 _2161_ (
    .A(\txf_mem[1] [5]),
    .B(PWDATA[5]),
    .S(_0655_),
    .Z(_0174_)
  );
  NAND3_X1 _2162_ (
    .A1(rxf_wptr[2]),
    .A2(rxf_wptr[3]),
    .A3(_0512_),
    .ZN(_0656_)
  );
  NAND3_X1 _2163_ (
    .A1(rxf_wptr[2]),
    .A2(rxf_wptr[3]),
    .A3(_0513_),
    .ZN(_0657_)
  );
  MUX2_X1 _2164_ (
    .A(rx_shift[7]),
    .B(\rxf_mem[15] [7]),
    .S(_0657_),
    .Z(_0175_)
  );
  MUX2_X1 _2165_ (
    .A(\txf_mem[1] [4]),
    .B(PWDATA[4]),
    .S(_0655_),
    .Z(_0176_)
  );
  MUX2_X1 _2166_ (
    .A(\txf_mem[1] [3]),
    .B(PWDATA[3]),
    .S(_0655_),
    .Z(_0177_)
  );
  MUX2_X1 _2167_ (
    .A(\txf_mem[1] [2]),
    .B(PWDATA[2]),
    .S(_0655_),
    .Z(_0178_)
  );
  MUX2_X1 _2168_ (
    .A(\txf_mem[1] [1]),
    .B(PWDATA[1]),
    .S(_0655_),
    .Z(_0179_)
  );
  MUX2_X1 _2169_ (
    .A(\txf_mem[1] [0]),
    .B(PWDATA[0]),
    .S(_0655_),
    .Z(_0180_)
  );
  MUX2_X1 _2170_ (
    .A(\txf_mem[2] [0]),
    .B(PWDATA[0]),
    .S(_0637_),
    .Z(_0181_)
  );
  NOR2_X1 _2171_ (
    .A1(_0494_),
    .A2(_0638_),
    .ZN(_0658_)
  );
  MUX2_X1 _2172_ (
    .A(\rxf_mem[12] [6]),
    .B(rx_shift[6]),
    .S(_0658_),
    .Z(_0182_)
  );
  MUX2_X1 _2173_ (
    .A(\rxf_mem[12] [5]),
    .B(rx_shift[5]),
    .S(_0658_),
    .Z(_0183_)
  );
  MUX2_X1 _2174_ (
    .A(\rxf_mem[12] [4]),
    .B(rx_shift[4]),
    .S(_0658_),
    .Z(_0184_)
  );
  OR3_X1 _2175_ (
    .A1(txf_wptr[0]),
    .A2(txf_wptr[1]),
    .A3(_0480_),
    .ZN(_0659_)
  );
  MUX2_X1 _2176_ (
    .A(PWDATA[7]),
    .B(\txf_mem[4] [7]),
    .S(_0659_),
    .Z(_0185_)
  );
  MUX2_X1 _2177_ (
    .A(\rxf_mem[12] [3]),
    .B(rx_shift[3]),
    .S(_0658_),
    .Z(_0186_)
  );
  MUX2_X1 _2178_ (
    .A(\rxf_mem[12] [7]),
    .B(rx_shift[7]),
    .S(_0658_),
    .Z(_0187_)
  );
  MUX2_X1 _2179_ (
    .A(\rxf_mem[12] [2]),
    .B(rx_shift[2]),
    .S(_0658_),
    .Z(_0188_)
  );
  MUX2_X1 _2180_ (
    .A(\rxf_mem[12] [1]),
    .B(rx_shift[1]),
    .S(_0658_),
    .Z(_0189_)
  );
  MUX2_X1 _2181_ (
    .A(\rxf_mem[12] [0]),
    .B(rx_shift[0]),
    .S(_0658_),
    .Z(_0190_)
  );
  MUX2_X1 _2182_ (
    .A(\txf_mem[1] [7]),
    .B(PWDATA[7]),
    .S(_0655_),
    .Z(_0191_)
  );
  AOI21_X1 _2183_ (
    .A(_0646_),
    .B1(_0642_),
    .B2(_0430_),
    .ZN(_0660_)
  );
  NOR3_X1 _2184_ (
    .A1(rx_state[1]),
    .A2(rx_state[3]),
    .A3(sin_s2),
    .ZN(_0661_)
  );
  NOR3_X1 _2185_ (
    .A1(_0423_),
    .A2(_0646_),
    .A3(_0661_),
    .ZN(_0662_)
  );
  NOR2_X1 _2186_ (
    .A1(rx_sub[3]),
    .A2(_0662_),
    .ZN(_0663_)
  );
  NOR2_X1 _2187_ (
    .A1(_0660_),
    .A2(_0663_),
    .ZN(_0192_)
  );
  MUX2_X1 _2188_ (
    .A(\rxf_mem[13] [7]),
    .B(rx_shift[7]),
    .S(_0639_),
    .Z(_0193_)
  );
  MUX2_X1 _2189_ (
    .A(PWDATA[6]),
    .B(\txf_mem[4] [6]),
    .S(_0659_),
    .Z(_0194_)
  );
  MUX2_X1 _2190_ (
    .A(PWDATA[5]),
    .B(\txf_mem[4] [5]),
    .S(_0659_),
    .Z(_0195_)
  );
  MUX2_X1 _2191_ (
    .A(PWDATA[4]),
    .B(\txf_mem[4] [4]),
    .S(_0659_),
    .Z(_0196_)
  );
  MUX2_X1 _2192_ (
    .A(PWDATA[3]),
    .B(\txf_mem[4] [3]),
    .S(_0659_),
    .Z(_0197_)
  );
  MUX2_X1 _2193_ (
    .A(PWDATA[2]),
    .B(\txf_mem[4] [2]),
    .S(_0659_),
    .Z(_0198_)
  );
  NAND2_X1 _2194_ (
    .A1(_0805_),
    .A2(_0464_),
    .ZN(_0664_)
  );
  MUX2_X1 _2195_ (
    .A(PWDATA[3]),
    .B(ier_r[3]),
    .S(_0664_),
    .Z(_0199_)
  );
  MUX2_X1 _2196_ (
    .A(PWDATA[1]),
    .B(\txf_mem[4] [1]),
    .S(_0659_),
    .Z(_0200_)
  );
  MUX2_X1 _2197_ (
    .A(PWDATA[0]),
    .B(\txf_mem[4] [0]),
    .S(_0659_),
    .Z(_0201_)
  );
  NAND2_X1 _2198_ (
    .A1(_0471_),
    .A2(_0529_),
    .ZN(_0665_)
  );
  MUX2_X1 _2199_ (
    .A(rx_shift[6]),
    .B(\rxf_mem[2] [6]),
    .S(_0665_),
    .Z(_0202_)
  );
  MUX2_X1 _2200_ (
    .A(rx_shift[6]),
    .B(\rxf_mem[15] [6]),
    .S(_0657_),
    .Z(_0203_)
  );
  MUX2_X1 _2201_ (
    .A(rx_shift[5]),
    .B(\rxf_mem[15] [5]),
    .S(_0657_),
    .Z(_0204_)
  );
  MUX2_X1 _2202_ (
    .A(rx_shift[4]),
    .B(\rxf_mem[15] [4]),
    .S(_0657_),
    .Z(_0205_)
  );
  MUX2_X1 _2203_ (
    .A(rx_shift[7]),
    .B(\rxf_mem[11] [7]),
    .S(_0636_),
    .Z(_0206_)
  );
  NAND3_X1 _2204_ (
    .A1(rx_bit_idx[0]),
    .A2(rx_bit_idx[1]),
    .A3(_0626_),
    .ZN(_0666_)
  );
  AOI22_X1 _2205_ (
    .A1(_0429_),
    .A2(_0626_),
    .B1(_0666_),
    .B2(_0757_),
    .ZN(_0207_)
  );
  MUX2_X1 _2206_ (
    .A(rx_shift[3]),
    .B(\rxf_mem[15] [3]),
    .S(_0657_),
    .Z(_0208_)
  );
  AOI22_X1 _2207_ (
    .A1(\txf_mem[9] [7]),
    .A2(_0554_),
    .B1(_0559_),
    .B2(\txf_mem[1] [7]),
    .ZN(_0667_)
  );
  AOI22_X1 _2208_ (
    .A1(\txf_mem[7] [7]),
    .A2(_0556_),
    .B1(_0560_),
    .B2(\txf_mem[12] [7]),
    .ZN(_0668_)
  );
  AOI22_X1 _2209_ (
    .A1(\txf_mem[0] [7]),
    .A2(_0548_),
    .B1(_0550_),
    .B2(\txf_mem[2] [7]),
    .ZN(_0669_)
  );
  AOI22_X1 _2210_ (
    .A1(\txf_mem[3] [7]),
    .A2(_0544_),
    .B1(_0552_),
    .B2(\txf_mem[4] [7]),
    .ZN(_0670_)
  );
  DFFR_X1 _2211_ (
    .CK(CLK),
    .D(_0332_),
    .Q(ier_r[0]),
    .QN(_0942_),
    .RN(RSTN)
  );
  DFFR_X1 _2212_ (
    .CK(CLK),
    .D(_0331_),
    .Q(ier_r[1]),
    .QN(_0943_),
    .RN(RSTN)
  );
  DFFR_X1 _2213_ (
    .CK(CLK),
    .D(_0330_),
    .Q(ier_r[2]),
    .QN(_0944_),
    .RN(RSTN)
  );
  DFFR_X1 _2214_ (
    .CK(CLK),
    .D(_0199_),
    .Q(ier_r[3]),
    .QN(_1071_),
    .RN(RSTN)
  );
  DFFR_X1 _2215_ (
    .CK(CLK),
    .D(_0328_),
    .Q(mcr_r[0]),
    .QN(DTRN),
    .RN(RSTN)
  );
  DFFR_X1 _2216_ (
    .CK(CLK),
    .D(_0326_),
    .Q(mcr_r[1]),
    .QN(RTSN),
    .RN(RSTN)
  );
  DFFR_X1 _2217_ (
    .CK(CLK),
    .D(_0325_),
    .Q(mcr_r[2]),
    .QN(OUT1N),
    .RN(RSTN)
  );
  DFFR_X1 _2218_ (
    .CK(CLK),
    .D(_0324_),
    .Q(mcr_r[3]),
    .QN(OUT2N),
    .RN(RSTN)
  );
  DFFR_X1 _2219_ (
    .CK(CLK),
    .D(_0157_),
    .Q(mcr_r[4]),
    .QN(_1112_),
    .RN(RSTN)
  );
  DFFS_X1 _2220_ (
    .CK(CLK),
    .D(_0323_),
    .Q(lcr_r[0]),
    .QN(_1274_),
    .SN(RSTN)
  );
  DFFS_X1 _2221_ (
    .CK(CLK),
    .D(_0322_),
    .Q(lcr_r[1]),
    .QN(_0948_),
    .SN(RSTN)
  );
  DFFR_X1 _2222_ (
    .CK(CLK),
    .D(_0321_),
    .Q(lcr_r[2]),
    .QN(_0949_),
    .RN(RSTN)
  );
  DFFR_X1 _2223_ (
    .CK(CLK),
    .D(_0319_),
    .Q(lcr_r[3]),
    .QN(_0951_),
    .RN(RSTN)
  );
  DFFR_X1 _2224_ (
    .CK(CLK),
    .D(_0318_),
    .Q(lcr_r[4]),
    .QN(_0952_),
    .RN(RSTN)
  );
  DFFR_X1 _2225_ (
    .CK(CLK),
    .D(_0317_),
    .Q(lcr_r[5]),
    .QN(_0953_),
    .RN(RSTN)
  );
  DFFR_X1 _2226_ (
    .CK(CLK),
    .D(_0314_),
    .Q(lcr_r[6]),
    .QN(_0956_),
    .RN(RSTN)
  );
  DFFR_X1 _2227_ (
    .CK(CLK),
    .D(_0127_),
    .Q(lcr_r[7]),
    .QN(_1142_),
    .RN(RSTN)
  );
  DFFR_X1 _2228_ (
    .CK(CLK),
    .D(_0313_),
    .Q(scr_r[0]),
    .QN(_0957_),
    .RN(RSTN)
  );
  DFFR_X1 _2229_ (
    .CK(CLK),
    .D(_0312_),
    .Q(scr_r[1]),
    .QN(_0958_),
    .RN(RSTN)
  );
  DFFR_X1 _2230_ (
    .CK(CLK),
    .D(_0310_),
    .Q(scr_r[2]),
    .QN(_0960_),
    .RN(RSTN)
  );
  DFFR_X1 _2231_ (
    .CK(CLK),
    .D(_0309_),
    .Q(scr_r[3]),
    .QN(_0961_),
    .RN(RSTN)
  );
  DFFR_X1 _2232_ (
    .CK(CLK),
    .D(_0308_),
    .Q(scr_r[4]),
    .QN(_0962_),
    .RN(RSTN)
  );
  DFFR_X1 _2233_ (
    .CK(CLK),
    .D(_0306_),
    .Q(scr_r[5]),
    .QN(_0964_),
    .RN(RSTN)
  );
  DFFR_X1 _2234_ (
    .CK(CLK),
    .D(_0304_),
    .Q(scr_r[6]),
    .QN(_0966_),
    .RN(RSTN)
  );
  DFFR_X1 _2235_ (
    .CK(CLK),
    .D(_0136_),
    .Q(scr_r[7]),
    .QN(_1133_),
    .RN(RSTN)
  );
  DFF_X1 _2236_ (
    .CK(CLK),
    .D(_0300_),
    .Q(\txf_mem[9] [0]),
    .QN(_0970_)
  );
  DFF_X1 _2237_ (
    .CK(CLK),
    .D(_0299_),
    .Q(\txf_mem[9] [1]),
    .QN(_0971_)
  );
  DFF_X1 _2238_ (
    .CK(CLK),
    .D(_0298_),
    .Q(\txf_mem[9] [2]),
    .QN(_0972_)
  );
  DFF_X1 _2239_ (
    .CK(CLK),
    .D(_0296_),
    .Q(\txf_mem[9] [3]),
    .QN(_0974_)
  );
  DFF_X1 _2240_ (
    .CK(CLK),
    .D(_0294_),
    .Q(\txf_mem[9] [4]),
    .QN(_0976_)
  );
  DFF_X1 _2241_ (
    .CK(CLK),
    .D(_0293_),
    .Q(\txf_mem[9] [5]),
    .QN(_0977_)
  );
  DFF_X1 _2242_ (
    .CK(CLK),
    .D(_0291_),
    .Q(\txf_mem[9] [6]),
    .QN(_0979_)
  );
  DFF_X1 _2243_ (
    .CK(CLK),
    .D(_0137_),
    .Q(\txf_mem[9] [7]),
    .QN(_1132_)
  );
  DFF_X1 _2244_ (
    .CK(CLK),
    .D(_0288_),
    .Q(\txf_mem[6] [0]),
    .QN(_0982_)
  );
  DFF_X1 _2245_ (
    .CK(CLK),
    .D(_0287_),
    .Q(\txf_mem[6] [1]),
    .QN(_0983_)
  );
  DFF_X1 _2246_ (
    .CK(CLK),
    .D(_0286_),
    .Q(\txf_mem[6] [2]),
    .QN(_0984_)
  );
  DFF_X1 _2247_ (
    .CK(CLK),
    .D(_0285_),
    .Q(\txf_mem[6] [3]),
    .QN(_0985_)
  );
  DFF_X1 _2248_ (
    .CK(CLK),
    .D(_0284_),
    .Q(\txf_mem[6] [4]),
    .QN(_0986_)
  );
  DFF_X1 _2249_ (
    .CK(CLK),
    .D(_0283_),
    .Q(\txf_mem[6] [5]),
    .QN(_0987_)
  );
  DFF_X1 _2250_ (
    .CK(CLK),
    .D(_0282_),
    .Q(\txf_mem[6] [6]),
    .QN(_0988_)
  );
  DFF_X1 _2251_ (
    .CK(CLK),
    .D(_0138_),
    .Q(\txf_mem[6] [7]),
    .QN(_1131_)
  );
  DFF_X1 _2252_ (
    .CK(CLK),
    .D(_0280_),
    .Q(\rxf_mem[8] [0]),
    .QN(_0990_)
  );
  DFF_X1 _2253_ (
    .CK(CLK),
    .D(_0279_),
    .Q(\rxf_mem[8] [1]),
    .QN(_0991_)
  );
  DFF_X1 _2254_ (
    .CK(CLK),
    .D(_0278_),
    .Q(\rxf_mem[8] [2]),
    .QN(_0992_)
  );
  DFF_X1 _2255_ (
    .CK(CLK),
    .D(_0277_),
    .Q(\rxf_mem[8] [3]),
    .QN(_0993_)
  );
  DFF_X1 _2256_ (
    .CK(CLK),
    .D(_0276_),
    .Q(\rxf_mem[8] [4]),
    .QN(_0994_)
  );
  DFF_X1 _2257_ (
    .CK(CLK),
    .D(_0275_),
    .Q(\rxf_mem[8] [5]),
    .QN(_0995_)
  );
  DFF_X1 _2258_ (
    .CK(CLK),
    .D(_0274_),
    .Q(\rxf_mem[8] [6]),
    .QN(_0996_)
  );
  DFF_X1 _2259_ (
    .CK(CLK),
    .D(_0141_),
    .Q(\rxf_mem[8] [7]),
    .QN(_1128_)
  );
  DFF_X1 _2260_ (
    .CK(CLK),
    .D(_0272_),
    .Q(\txf_mem[5] [0]),
    .QN(_0998_)
  );
  DFF_X1 _2261_ (
    .CK(CLK),
    .D(_0271_),
    .Q(\txf_mem[5] [1]),
    .QN(_0999_)
  );
  DFF_X1 _2262_ (
    .CK(CLK),
    .D(_0270_),
    .Q(\txf_mem[5] [2]),
    .QN(_1000_)
  );
  DFF_X1 _2263_ (
    .CK(CLK),
    .D(_0269_),
    .Q(\txf_mem[5] [3]),
    .QN(_1001_)
  );
  DFF_X1 _2264_ (
    .CK(CLK),
    .D(_0268_),
    .Q(\txf_mem[5] [4]),
    .QN(_1002_)
  );
  DFF_X1 _2265_ (
    .CK(CLK),
    .D(_0267_),
    .Q(\txf_mem[5] [5]),
    .QN(_1003_)
  );
  DFF_X1 _2266_ (
    .CK(CLK),
    .D(_0266_),
    .Q(\txf_mem[5] [6]),
    .QN(_1004_)
  );
  DFF_X1 _2267_ (
    .CK(CLK),
    .D(_0143_),
    .Q(\txf_mem[5] [7]),
    .QN(_1126_)
  );
  DFF_X1 _2268_ (
    .CK(CLK),
    .D(_0264_),
    .Q(\txf_mem[10] [0]),
    .QN(_1006_)
  );
  DFF_X1 _2269_ (
    .CK(CLK),
    .D(_0263_),
    .Q(\txf_mem[10] [1]),
    .QN(_1007_)
  );
  DFF_X1 _2270_ (
    .CK(CLK),
    .D(_0262_),
    .Q(\txf_mem[10] [2]),
    .QN(_1008_)
  );
  DFF_X1 _2271_ (
    .CK(CLK),
    .D(_0261_),
    .Q(\txf_mem[10] [3]),
    .QN(_1009_)
  );
  DFF_X1 _2272_ (
    .CK(CLK),
    .D(_0260_),
    .Q(\txf_mem[10] [4]),
    .QN(_1010_)
  );
  DFF_X1 _2273_ (
    .CK(CLK),
    .D(_0259_),
    .Q(\txf_mem[10] [5]),
    .QN(_1011_)
  );
  DFF_X1 _2274_ (
    .CK(CLK),
    .D(_0258_),
    .Q(\txf_mem[10] [6]),
    .QN(_1012_)
  );
  DFF_X1 _2275_ (
    .CK(CLK),
    .D(_0161_),
    .Q(\txf_mem[10] [7]),
    .QN(_1108_)
  );
  DFFR_X1 _2276_ (
    .CK(CLK),
    .D(_0256_),
    .Q(dlm_r[0]),
    .QN(_1014_),
    .RN(RSTN)
  );
  DFFR_X1 _2277_ (
    .CK(CLK),
    .D(_0255_),
    .Q(dlm_r[1]),
    .QN(_1015_),
    .RN(RSTN)
  );
  DFFR_X1 _2278_ (
    .CK(CLK),
    .D(_0254_),
    .Q(dlm_r[2]),
    .QN(_1016_),
    .RN(RSTN)
  );
  DFFR_X1 _2279_ (
    .CK(CLK),
    .D(_0253_),
    .Q(dlm_r[3]),
    .QN(_1017_),
    .RN(RSTN)
  );
  DFFR_X1 _2280_ (
    .CK(CLK),
    .D(_0252_),
    .Q(dlm_r[4]),
    .QN(_1018_),
    .RN(RSTN)
  );
  DFFR_X1 _2281_ (
    .CK(CLK),
    .D(_0251_),
    .Q(dlm_r[5]),
    .QN(_1019_),
    .RN(RSTN)
  );
  DFFR_X1 _2282_ (
    .CK(CLK),
    .D(_0250_),
    .Q(dlm_r[6]),
    .QN(_1020_),
    .RN(RSTN)
  );
  DFFR_X1 _2283_ (
    .CK(CLK),
    .D(_0165_),
    .Q(dlm_r[7]),
    .QN(_1105_),
    .RN(RSTN)
  );
  DFF_X1 _2284_ (
    .CK(CLK),
    .D(_0248_),
    .Q(\txf_mem[15] [0]),
    .QN(_1022_)
  );
  DFF_X1 _2285_ (
    .CK(CLK),
    .D(_0247_),
    .Q(\txf_mem[15] [1]),
    .QN(_1023_)
  );
  DFF_X1 _2286_ (
    .CK(CLK),
    .D(_0246_),
    .Q(\txf_mem[15] [2]),
    .QN(_1024_)
  );
  DFF_X1 _2287_ (
    .CK(CLK),
    .D(_0245_),
    .Q(\txf_mem[15] [3]),
    .QN(_1025_)
  );
  DFF_X1 _2288_ (
    .CK(CLK),
    .D(_0244_),
    .Q(\txf_mem[15] [4]),
    .QN(_1026_)
  );
  DFF_X1 _2289_ (
    .CK(CLK),
    .D(_0243_),
    .Q(\txf_mem[15] [5]),
    .QN(_1027_)
  );
  DFF_X1 _2290_ (
    .CK(CLK),
    .D(_0242_),
    .Q(\txf_mem[15] [6]),
    .QN(_1028_)
  );
  DFF_X1 _2291_ (
    .CK(CLK),
    .D(_0168_),
    .Q(\txf_mem[15] [7]),
    .QN(_1102_)
  );
  DFF_X1 _2292_ (
    .CK(CLK),
    .D(_0238_),
    .Q(\rxf_mem[7] [0]),
    .QN(_1032_)
  );
  DFF_X1 _2293_ (
    .CK(CLK),
    .D(_0236_),
    .Q(\rxf_mem[7] [1]),
    .QN(_1034_)
  );
  DFF_X1 _2294_ (
    .CK(CLK),
    .D(_0235_),
    .Q(\rxf_mem[7] [2]),
    .QN(_1035_)
  );
  DFF_X1 _2295_ (
    .CK(CLK),
    .D(_0234_),
    .Q(\rxf_mem[7] [3]),
    .QN(_1036_)
  );
  DFF_X1 _2296_ (
    .CK(CLK),
    .D(_0232_),
    .Q(\rxf_mem[7] [4]),
    .QN(_1038_)
  );
  DFF_X1 _2297_ (
    .CK(CLK),
    .D(_0231_),
    .Q(\rxf_mem[7] [5]),
    .QN(_1039_)
  );
  DFF_X1 _2298_ (
    .CK(CLK),
    .D(_0230_),
    .Q(\rxf_mem[7] [6]),
    .QN(_1040_)
  );
  DFF_X1 _2299_ (
    .CK(CLK),
    .D(_0170_),
    .Q(\rxf_mem[7] [7]),
    .QN(_1100_)
  );
  DFFS_X1 _2300_ (
    .CK(CLK),
    .D(_0222_),
    .Q(dll_r[0]),
    .QN(_1048_),
    .SN(RSTN)
  );
  DFFR_X1 _2301_ (
    .CK(CLK),
    .D(_0221_),
    .Q(dll_r[1]),
    .QN(_1049_),
    .RN(RSTN)
  );
  DFFR_X1 _2302_ (
    .CK(CLK),
    .D(_0219_),
    .Q(dll_r[2]),
    .QN(_1051_),
    .RN(RSTN)
  );
  DFFR_X1 _2303_ (
    .CK(CLK),
    .D(_0217_),
    .Q(dll_r[3]),
    .QN(_1053_),
    .RN(RSTN)
  );
  DFFR_X1 _2304_ (
    .CK(CLK),
    .D(_0216_),
    .Q(dll_r[4]),
    .QN(_1054_),
    .RN(RSTN)
  );
  DFFR_X1 _2305_ (
    .CK(CLK),
    .D(_0215_),
    .Q(dll_r[5]),
    .QN(_1055_),
    .RN(RSTN)
  );
  DFFR_X1 _2306_ (
    .CK(CLK),
    .D(_0214_),
    .Q(dll_r[6]),
    .QN(_1056_),
    .RN(RSTN)
  );
  DFFR_X1 _2307_ (
    .CK(CLK),
    .D(_0172_),
    .Q(dll_r[7]),
    .QN(_1098_),
    .RN(RSTN)
  );
  DFF_X1 _2308_ (
    .CK(CLK),
    .D(_0212_),
    .Q(\rxf_mem[15] [0]),
    .QN(_1058_)
  );
  DFF_X1 _2309_ (
    .CK(CLK),
    .D(_0211_),
    .Q(\rxf_mem[15] [1]),
    .QN(_1059_)
  );
  DFF_X1 _2310_ (
    .CK(CLK),
    .D(_0210_),
    .Q(\rxf_mem[15] [2]),
    .QN(_1060_)
  );
  DFF_X1 _2311_ (
    .CK(CLK),
    .D(_0208_),
    .Q(\rxf_mem[15] [3]),
    .QN(_1062_)
  );
  DFF_X1 _2312_ (
    .CK(CLK),
    .D(_0205_),
    .Q(\rxf_mem[15] [4]),
    .QN(_1065_)
  );
  DFF_X1 _2313_ (
    .CK(CLK),
    .D(_0204_),
    .Q(\rxf_mem[15] [5]),
    .QN(_1066_)
  );
  DFF_X1 _2314_ (
    .CK(CLK),
    .D(_0203_),
    .Q(\rxf_mem[15] [6]),
    .QN(_1067_)
  );
  DFF_X1 _2315_ (
    .CK(CLK),
    .D(_0175_),
    .Q(\rxf_mem[15] [7]),
    .QN(_1095_)
  );
  DFF_X1 _2316_ (
    .CK(CLK),
    .D(_0201_),
    .Q(\txf_mem[4] [0]),
    .QN(_1069_)
  );
  DFF_X1 _2317_ (
    .CK(CLK),
    .D(_0200_),
    .Q(\txf_mem[4] [1]),
    .QN(_1271_)
  );
  DFF_X1 _2318_ (
    .CK(CLK),
    .D(_0198_),
    .Q(\txf_mem[4] [2]),
    .QN(_1072_)
  );
  DFF_X1 _2319_ (
    .CK(CLK),
    .D(_0197_),
    .Q(\txf_mem[4] [3]),
    .QN(_1073_)
  );
  DFF_X1 _2320_ (
    .CK(CLK),
    .D(_0196_),
    .Q(\txf_mem[4] [4]),
    .QN(_1074_)
  );
  DFF_X1 _2321_ (
    .CK(CLK),
    .D(_0195_),
    .Q(\txf_mem[4] [5]),
    .QN(_1075_)
  );
  DFF_X1 _2322_ (
    .CK(CLK),
    .D(_0194_),
    .Q(\txf_mem[4] [6]),
    .QN(_1076_)
  );
  DFF_X1 _2323_ (
    .CK(CLK),
    .D(_0185_),
    .Q(\txf_mem[4] [7]),
    .QN(_1085_)
  );
  DFF_X1 _2324_ (
    .CK(CLK),
    .D(_0190_),
    .Q(\rxf_mem[12] [0]),
    .QN(_1080_)
  );
  DFF_X1 _2325_ (
    .CK(CLK),
    .D(_0189_),
    .Q(\rxf_mem[12] [1]),
    .QN(_1081_)
  );
  DFF_X1 _2326_ (
    .CK(CLK),
    .D(_0188_),
    .Q(\rxf_mem[12] [2]),
    .QN(_1082_)
  );
  DFF_X1 _2327_ (
    .CK(CLK),
    .D(_0186_),
    .Q(\rxf_mem[12] [3]),
    .QN(_1084_)
  );
  DFF_X1 _2328_ (
    .CK(CLK),
    .D(_0184_),
    .Q(\rxf_mem[12] [4]),
    .QN(_1086_)
  );
  DFF_X1 _2329_ (
    .CK(CLK),
    .D(_0183_),
    .Q(\rxf_mem[12] [5]),
    .QN(_1087_)
  );
  DFF_X1 _2330_ (
    .CK(CLK),
    .D(_0182_),
    .Q(\rxf_mem[12] [6]),
    .QN(_1088_)
  );
  DFF_X1 _2331_ (
    .CK(CLK),
    .D(_0187_),
    .Q(\rxf_mem[12] [7]),
    .QN(_1083_)
  );
  DFF_X1 _2332_ (
    .CK(CLK),
    .D(_0180_),
    .Q(\txf_mem[1] [0]),
    .QN(_1269_)
  );
  DFF_X1 _2333_ (
    .CK(CLK),
    .D(_0179_),
    .Q(\txf_mem[1] [1]),
    .QN(_1091_)
  );
  DFF_X1 _2334_ (
    .CK(CLK),
    .D(_0178_),
    .Q(\txf_mem[1] [2]),
    .QN(_1092_)
  );
  DFF_X1 _2335_ (
    .CK(CLK),
    .D(_0177_),
    .Q(\txf_mem[1] [3]),
    .QN(_1093_)
  );
  DFF_X1 _2336_ (
    .CK(CLK),
    .D(_0176_),
    .Q(\txf_mem[1] [4]),
    .QN(_1094_)
  );
  DFF_X1 _2337_ (
    .CK(CLK),
    .D(_0174_),
    .Q(\txf_mem[1] [5]),
    .QN(_1096_)
  );
  DFF_X1 _2338_ (
    .CK(CLK),
    .D(_0173_),
    .Q(\txf_mem[1] [6]),
    .QN(_1097_)
  );
  DFF_X1 _2339_ (
    .CK(CLK),
    .D(_0191_),
    .Q(\txf_mem[1] [7]),
    .QN(_1079_)
  );
  DFFR_X1 _2340_ (
    .CK(CLK),
    .D(_0164_),
    .Q(rx_sub[0]),
    .QN(_0011_),
    .RN(RSTN)
  );
  DFFR_X1 _2341_ (
    .CK(CLK),
    .D(_0163_),
    .Q(rx_sub[1]),
    .QN(_1106_),
    .RN(RSTN)
  );
  DFFR_X1 _2342_ (
    .CK(CLK),
    .D(_0162_),
    .Q(rx_sub[2]),
    .QN(_1107_),
    .RN(RSTN)
  );
  DFFR_X1 _2343_ (
    .CK(CLK),
    .D(_0192_),
    .Q(rx_sub[3]),
    .QN(_1270_),
    .RN(RSTN)
  );
  DFF_X1 _2344_ (
    .CK(CLK),
    .D(_0159_),
    .Q(\rxf_mem[13] [0]),
    .QN(_1110_)
  );
  DFF_X1 _2345_ (
    .CK(CLK),
    .D(_0158_),
    .Q(\rxf_mem[13] [1]),
    .QN(_1111_)
  );
  DFF_X1 _2346_ (
    .CK(CLK),
    .D(_0156_),
    .Q(\rxf_mem[13] [2]),
    .QN(_1113_)
  );
  DFF_X1 _2347_ (
    .CK(CLK),
    .D(_0155_),
    .Q(\rxf_mem[13] [3]),
    .QN(_1114_)
  );
  DFF_X1 _2348_ (
    .CK(CLK),
    .D(_0154_),
    .Q(\rxf_mem[13] [4]),
    .QN(_1115_)
  );
  DFF_X1 _2349_ (
    .CK(CLK),
    .D(_0153_),
    .Q(\rxf_mem[13] [5]),
    .QN(_1116_)
  );
  DFF_X1 _2350_ (
    .CK(CLK),
    .D(_0152_),
    .Q(\rxf_mem[13] [6]),
    .QN(_1117_)
  );
  DFF_X1 _2351_ (
    .CK(CLK),
    .D(_0193_),
    .Q(\rxf_mem[13] [7]),
    .QN(_1077_)
  );
  DFF_X1 _2352_ (
    .CK(CLK),
    .D(_0150_),
    .Q(\rxf_mem[11] [0]),
    .QN(_1119_)
  );
  DFF_X1 _2353_ (
    .CK(CLK),
    .D(_0149_),
    .Q(\rxf_mem[11] [1]),
    .QN(_1120_)
  );
  DFF_X1 _2354_ (
    .CK(CLK),
    .D(_0148_),
    .Q(\rxf_mem[11] [2]),
    .QN(_1121_)
  );
  DFF_X1 _2355_ (
    .CK(CLK),
    .D(_0147_),
    .Q(\rxf_mem[11] [3]),
    .QN(_1122_)
  );
  DFF_X1 _2356_ (
    .CK(CLK),
    .D(_0146_),
    .Q(\rxf_mem[11] [4]),
    .QN(_1123_)
  );
  DFF_X1 _2357_ (
    .CK(CLK),
    .D(_0145_),
    .Q(\rxf_mem[11] [5]),
    .QN(_1124_)
  );
  DFF_X1 _2358_ (
    .CK(CLK),
    .D(_0144_),
    .Q(\rxf_mem[11] [6]),
    .QN(_1125_)
  );
  DFF_X1 _2359_ (
    .CK(CLK),
    .D(_0206_),
    .Q(\rxf_mem[11] [7]),
    .QN(_1064_)
  );
  DFFR_X1 _2360_ (
    .CK(CLK),
    .D(_0130_),
    .Q(rx_bit_idx[0]),
    .QN(_1139_),
    .RN(RSTN)
  );
  DFFR_X1 _2361_ (
    .CK(CLK),
    .D(_0129_),
    .Q(rx_bit_idx[1]),
    .QN(_1140_),
    .RN(RSTN)
  );
  DFFR_X1 _2362_ (
    .CK(CLK),
    .D(_0207_),
    .Q(rx_bit_idx[2]),
    .QN(_1063_),
    .RN(RSTN)
  );
  DFFS_X1 _2363_ (
    .CK(CLK),
    .D(_0126_),
    .Q(tx_shift[0]),
    .QN(_1143_),
    .SN(RSTN)
  );
  DFFS_X1 _2364_ (
    .CK(CLK),
    .D(_0125_),
    .Q(tx_shift[1]),
    .QN(_1144_),
    .SN(RSTN)
  );
  DFFS_X1 _2365_ (
    .CK(CLK),
    .D(_0124_),
    .Q(tx_shift[2]),
    .QN(_1145_),
    .SN(RSTN)
  );
  DFFS_X1 _2366_ (
    .CK(CLK),
    .D(_0123_),
    .Q(tx_shift[3]),
    .QN(_1146_),
    .SN(RSTN)
  );
  DFFS_X1 _2367_ (
    .CK(CLK),
    .D(_0122_),
    .Q(tx_shift[4]),
    .QN(_1147_),
    .SN(RSTN)
  );
  DFFS_X1 _2368_ (
    .CK(CLK),
    .D(_0121_),
    .Q(tx_shift[5]),
    .QN(_1148_),
    .SN(RSTN)
  );
  DFFS_X1 _2369_ (
    .CK(CLK),
    .D(_0120_),
    .Q(tx_shift[6]),
    .QN(_1149_),
    .SN(RSTN)
  );
  DFFS_X1 _2370_ (
    .CK(CLK),
    .D(_0209_),
    .Q(tx_shift[7]),
    .QN(_1061_),
    .SN(RSTN)
  );
  DFF_X1 _2371_ (
    .CK(CLK),
    .D(_0118_),
    .Q(\rxf_mem[6] [0]),
    .QN(_1151_)
  );
  DFF_X1 _2372_ (
    .CK(CLK),
    .D(_0117_),
    .Q(\rxf_mem[6] [1]),
    .QN(_1152_)
  );
  DFF_X1 _2373_ (
    .CK(CLK),
    .D(_0116_),
    .Q(\rxf_mem[6] [2]),
    .QN(_1153_)
  );
  DFF_X1 _2374_ (
    .CK(CLK),
    .D(_0115_),
    .Q(\rxf_mem[6] [3]),
    .QN(_1154_)
  );
  DFF_X1 _2375_ (
    .CK(CLK),
    .D(_0114_),
    .Q(\rxf_mem[6] [4]),
    .QN(_1155_)
  );
  DFF_X1 _2376_ (
    .CK(CLK),
    .D(_0113_),
    .Q(\rxf_mem[6] [5]),
    .QN(_1156_)
  );
  DFF_X1 _2377_ (
    .CK(CLK),
    .D(_0112_),
    .Q(\rxf_mem[6] [6]),
    .QN(_1157_)
  );
  DFF_X1 _2378_ (
    .CK(CLK),
    .D(_0218_),
    .Q(\rxf_mem[6] [7]),
    .QN(_1052_)
  );
  DFFR_X1 _2379_ (
    .CK(CLK),
    .D(_0220_),
    .Q(lsr_oe_r),
    .QN(_1050_),
    .RN(RSTN)
  );
  DFFR_X1 _2380_ (
    .CK(CLK),
    .D(_0111_),
    .Q(rxf_rptr[0]),
    .QN(_0910_[0]),
    .RN(RSTN)
  );
  DFFR_X1 _2381_ (
    .CK(CLK),
    .D(_0110_),
    .Q(rxf_rptr[1]),
    .QN(_1158_),
    .RN(RSTN)
  );
  DFFR_X1 _2382_ (
    .CK(CLK),
    .D(_0109_),
    .Q(rxf_rptr[2]),
    .QN(_1159_),
    .RN(RSTN)
  );
  DFFR_X1 _2383_ (
    .CK(CLK),
    .D(_0108_),
    .Q(rxf_rptr[3]),
    .QN(_1160_),
    .RN(RSTN)
  );
  DFFR_X1 _2384_ (
    .CK(CLK),
    .D(_0224_),
    .Q(rxf_rptr[4]),
    .QN(_1046_),
    .RN(RSTN)
  );
  DFF_X1 _2385_ (
    .CK(CLK),
    .D(_0106_),
    .Q(\rxf_mem[9] [0]),
    .QN(_1162_)
  );
  DFF_X1 _2386_ (
    .CK(CLK),
    .D(_0105_),
    .Q(\rxf_mem[9] [1]),
    .QN(_1163_)
  );
  DFF_X1 _2387_ (
    .CK(CLK),
    .D(_0104_),
    .Q(\rxf_mem[9] [2]),
    .QN(_1164_)
  );
  DFF_X1 _2388_ (
    .CK(CLK),
    .D(_0103_),
    .Q(\rxf_mem[9] [3]),
    .QN(_1165_)
  );
  DFF_X1 _2389_ (
    .CK(CLK),
    .D(_0102_),
    .Q(\rxf_mem[9] [4]),
    .QN(_1166_)
  );
  DFF_X1 _2390_ (
    .CK(CLK),
    .D(_0101_),
    .Q(\rxf_mem[9] [5]),
    .QN(_1167_)
  );
  DFF_X1 _2391_ (
    .CK(CLK),
    .D(_0100_),
    .Q(\rxf_mem[9] [6]),
    .QN(_1168_)
  );
  DFF_X1 _2392_ (
    .CK(CLK),
    .D(_0225_),
    .Q(\rxf_mem[9] [7]),
    .QN(_1045_)
  );
  DFF_X1 _2393_ (
    .CK(CLK),
    .D(_0098_),
    .Q(\txf_mem[13] [0]),
    .QN(_1170_)
  );
  DFF_X1 _2394_ (
    .CK(CLK),
    .D(_0097_),
    .Q(\txf_mem[13] [1]),
    .QN(_1171_)
  );
  DFF_X1 _2395_ (
    .CK(CLK),
    .D(_0096_),
    .Q(\txf_mem[13] [2]),
    .QN(_1172_)
  );
  DFF_X1 _2396_ (
    .CK(CLK),
    .D(_0095_),
    .Q(\txf_mem[13] [3]),
    .QN(_1173_)
  );
  DFF_X1 _2397_ (
    .CK(CLK),
    .D(_0094_),
    .Q(\txf_mem[13] [4]),
    .QN(_1174_)
  );
  DFF_X1 _2398_ (
    .CK(CLK),
    .D(_0093_),
    .Q(\txf_mem[13] [5]),
    .QN(_1175_)
  );
  DFF_X1 _2399_ (
    .CK(CLK),
    .D(_0092_),
    .Q(\txf_mem[13] [6]),
    .QN(_1176_)
  );
  DFF_X1 _2400_ (
    .CK(CLK),
    .D(_0226_),
    .Q(\txf_mem[13] [7]),
    .QN(_1044_)
  );
  DFFR_X1 _2401_ (
    .CK(CLK),
    .D(_0091_),
    .Q(rxf_wptr[0]),
    .QN(_0911_[0]),
    .RN(RSTN)
  );
  DFFR_X1 _2402_ (
    .CK(CLK),
    .D(_0090_),
    .Q(rxf_wptr[1]),
    .QN(_1177_),
    .RN(RSTN)
  );
  DFFR_X1 _2403_ (
    .CK(CLK),
    .D(_0089_),
    .Q(rxf_wptr[2]),
    .QN(_1178_),
    .RN(RSTN)
  );
  DFFR_X1 _2404_ (
    .CK(CLK),
    .D(_0088_),
    .Q(rxf_wptr[3]),
    .QN(_1179_),
    .RN(RSTN)
  );
  DFFR_X1 _2405_ (
    .CK(CLK),
    .D(_0227_),
    .Q(rxf_wptr[4]),
    .QN(_1043_),
    .RN(RSTN)
  );
  DFFR_X1 _2406_ (
    .CK(CLK),
    .D(_0085_),
    .Q(rx_shift[0]),
    .QN(_1265_),
    .RN(RSTN)
  );
  DFFR_X1 _2407_ (
    .CK(CLK),
    .D(_0084_),
    .Q(rx_shift[1]),
    .QN(_1183_),
    .RN(RSTN)
  );
  DFFR_X1 _2408_ (
    .CK(CLK),
    .D(_0083_),
    .Q(rx_shift[2]),
    .QN(_1184_),
    .RN(RSTN)
  );
  DFFR_X1 _2409_ (
    .CK(CLK),
    .D(_0082_),
    .Q(rx_shift[3]),
    .QN(_1185_),
    .RN(RSTN)
  );
  DFFR_X1 _2410_ (
    .CK(CLK),
    .D(_0081_),
    .Q(rx_shift[4]),
    .QN(_1186_),
    .RN(RSTN)
  );
  DFFR_X1 _2411_ (
    .CK(CLK),
    .D(_0080_),
    .Q(rx_shift[5]),
    .QN(_1187_),
    .RN(RSTN)
  );
  DFFR_X1 _2412_ (
    .CK(CLK),
    .D(_0079_),
    .Q(rx_shift[6]),
    .QN(_1188_),
    .RN(RSTN)
  );
  DFFR_X1 _2413_ (
    .CK(CLK),
    .D(_0228_),
    .Q(rx_shift[7]),
    .QN(_1042_),
    .RN(RSTN)
  );
  DFFR_X1 _2414_ (
    .CK(CLK),
    .D(_0071_),
    .Q(tx_bit_idx[0]),
    .QN(_1262_),
    .RN(RSTN)
  );
  DFFR_X1 _2415_ (
    .CK(CLK),
    .D(_0070_),
    .Q(tx_bit_idx[1]),
    .QN(_1197_),
    .RN(RSTN)
  );
  DFFR_X1 _2416_ (
    .CK(CLK),
    .D(_0229_),
    .Q(tx_bit_idx[2]),
    .QN(_1041_),
    .RN(RSTN)
  );
  DFFR_X1 _2417_ (
    .CK(CLK),
    .D(_0069_),
    .Q(tx_sub[0]),
    .QN(_0012_),
    .RN(RSTN)
  );
  DFFR_X1 _2418_ (
    .CK(CLK),
    .D(_0068_),
    .Q(tx_sub[1]),
    .QN(_1199_),
    .RN(RSTN)
  );
  DFFR_X1 _2419_ (
    .CK(CLK),
    .D(_0067_),
    .Q(tx_sub[2]),
    .QN(_1200_),
    .RN(RSTN)
  );
  DFFR_X1 _2420_ (
    .CK(CLK),
    .D(_0233_),
    .Q(tx_sub[3]),
    .QN(_1037_),
    .RN(RSTN)
  );
  DFF_X1 _2421_ (
    .CK(CLK),
    .D(_0066_),
    .Q(\rxf_mem[0] [0]),
    .QN(_1259_)
  );
  DFF_X1 _2422_ (
    .CK(CLK),
    .D(_0065_),
    .Q(\rxf_mem[0] [1]),
    .QN(_1202_)
  );
  DFF_X1 _2423_ (
    .CK(CLK),
    .D(_0064_),
    .Q(\rxf_mem[0] [2]),
    .QN(_1203_)
  );
  DFF_X1 _2424_ (
    .CK(CLK),
    .D(_0063_),
    .Q(\rxf_mem[0] [3]),
    .QN(_1204_)
  );
  DFF_X1 _2425_ (
    .CK(CLK),
    .D(_0062_),
    .Q(\rxf_mem[0] [4]),
    .QN(_1205_)
  );
  DFF_X1 _2426_ (
    .CK(CLK),
    .D(_0061_),
    .Q(\rxf_mem[0] [5]),
    .QN(_1206_)
  );
  DFF_X1 _2427_ (
    .CK(CLK),
    .D(_0060_),
    .Q(\rxf_mem[0] [6]),
    .QN(_1207_)
  );
  DFF_X1 _2428_ (
    .CK(CLK),
    .D(_0237_),
    .Q(\rxf_mem[0] [7]),
    .QN(_1033_)
  );
  DFF_X1 _2429_ (
    .CK(CLK),
    .D(_0059_),
    .Q(\rxf_mem[4] [0]),
    .QN(_1258_)
  );
  DFF_X1 _2430_ (
    .CK(CLK),
    .D(_0058_),
    .Q(\rxf_mem[4] [1]),
    .QN(_1209_)
  );
  DFF_X1 _2431_ (
    .CK(CLK),
    .D(_0057_),
    .Q(\rxf_mem[4] [2]),
    .QN(_1210_)
  );
  DFF_X1 _2432_ (
    .CK(CLK),
    .D(_0056_),
    .Q(\rxf_mem[4] [3]),
    .QN(_1211_)
  );
  DFF_X1 _2433_ (
    .CK(CLK),
    .D(_0055_),
    .Q(\rxf_mem[4] [4]),
    .QN(_1212_)
  );
  DFF_X1 _2434_ (
    .CK(CLK),
    .D(_0054_),
    .Q(\rxf_mem[4] [5]),
    .QN(_1213_)
  );
  DFF_X1 _2435_ (
    .CK(CLK),
    .D(_0053_),
    .Q(\rxf_mem[4] [6]),
    .QN(_1214_)
  );
  DFF_X1 _2436_ (
    .CK(CLK),
    .D(_0239_),
    .Q(\rxf_mem[4] [7]),
    .QN(_1031_)
  );
  DFF_X1 _2437_ (
    .CK(CLK),
    .D(_0052_),
    .Q(\txf_mem[3] [0]),
    .QN(_1257_)
  );
  DFF_X1 _2438_ (
    .CK(CLK),
    .D(_0051_),
    .Q(\txf_mem[3] [1]),
    .QN(_1216_)
  );
  DFF_X1 _2439_ (
    .CK(CLK),
    .D(_0050_),
    .Q(\txf_mem[3] [2]),
    .QN(_1217_)
  );
  DFF_X1 _2440_ (
    .CK(CLK),
    .D(_0049_),
    .Q(\txf_mem[3] [3]),
    .QN(_1218_)
  );
  DFF_X1 _2441_ (
    .CK(CLK),
    .D(_0048_),
    .Q(\txf_mem[3] [4]),
    .QN(_1219_)
  );
  DFF_X1 _2442_ (
    .CK(CLK),
    .D(_0047_),
    .Q(\txf_mem[3] [5]),
    .QN(_1220_)
  );
  DFF_X1 _2443_ (
    .CK(CLK),
    .D(_0046_),
    .Q(\txf_mem[3] [6]),
    .QN(_1221_)
  );
  DFF_X1 _2444_ (
    .CK(CLK),
    .D(_0240_),
    .Q(\txf_mem[3] [7]),
    .QN(_1030_)
  );
  DFFR_X1 _2445_ (
    .CK(CLK),
    .D(_0045_),
    .Q(txf_wptr[0]),
    .QN(_0913_[0]),
    .RN(RSTN)
  );
  DFFR_X1 _2446_ (
    .CK(CLK),
    .D(_0044_),
    .Q(txf_wptr[1]),
    .QN(_1222_),
    .RN(RSTN)
  );
  DFFR_X1 _2447_ (
    .CK(CLK),
    .D(_0043_),
    .Q(txf_wptr[2]),
    .QN(_1223_),
    .RN(RSTN)
  );
  DFFR_X1 _2448_ (
    .CK(CLK),
    .D(_0042_),
    .Q(txf_wptr[3]),
    .QN(_1224_),
    .RN(RSTN)
  );
  DFFR_X1 _2449_ (
    .CK(CLK),
    .D(_0289_),
    .Q(txf_wptr[4]),
    .QN(_0981_),
    .RN(RSTN)
  );
  DFF_X1 _2450_ (
    .CK(CLK),
    .D(_0041_),
    .Q(\txf_mem[11] [0]),
    .QN(_1256_)
  );
  DFF_X1 _2451_ (
    .CK(CLK),
    .D(_0040_),
    .Q(\txf_mem[11] [1]),
    .QN(_1226_)
  );
  DFF_X1 _2452_ (
    .CK(CLK),
    .D(_0039_),
    .Q(\txf_mem[11] [2]),
    .QN(_1227_)
  );
  DFF_X1 _2453_ (
    .CK(CLK),
    .D(_0038_),
    .Q(\txf_mem[11] [3]),
    .QN(_1228_)
  );
  DFF_X1 _2454_ (
    .CK(CLK),
    .D(_0037_),
    .Q(\txf_mem[11] [4]),
    .QN(_1229_)
  );
  DFF_X1 _2455_ (
    .CK(CLK),
    .D(_0036_),
    .Q(\txf_mem[11] [5]),
    .QN(_1230_)
  );
  DFF_X1 _2456_ (
    .CK(CLK),
    .D(_0035_),
    .Q(\txf_mem[11] [6]),
    .QN(_1231_)
  );
  DFF_X1 _2457_ (
    .CK(CLK),
    .D(_0292_),
    .Q(\txf_mem[11] [7]),
    .QN(_0978_)
  );
  DFF_X1 _2458_ (
    .CK(CLK),
    .D(_0034_),
    .Q(\txf_mem[7] [0]),
    .QN(_1255_)
  );
  DFF_X1 _2459_ (
    .CK(CLK),
    .D(_0033_),
    .Q(\txf_mem[7] [1]),
    .QN(_1233_)
  );
  DFF_X1 _2460_ (
    .CK(CLK),
    .D(_0032_),
    .Q(\txf_mem[7] [2]),
    .QN(_1234_)
  );
  DFF_X1 _2461_ (
    .CK(CLK),
    .D(_0031_),
    .Q(\txf_mem[7] [3]),
    .QN(_1235_)
  );
  DFF_X1 _2462_ (
    .CK(CLK),
    .D(_0030_),
    .Q(\txf_mem[7] [4]),
    .QN(_1236_)
  );
  DFF_X1 _2463_ (
    .CK(CLK),
    .D(_0029_),
    .Q(\txf_mem[7] [5]),
    .QN(_1237_)
  );
  DFF_X1 _2464_ (
    .CK(CLK),
    .D(_0028_),
    .Q(\txf_mem[7] [6]),
    .QN(_1238_)
  );
  DFF_X1 _2465_ (
    .CK(CLK),
    .D(_0295_),
    .Q(\txf_mem[7] [7]),
    .QN(_0975_)
  );
  DFF_X1 _2466_ (
    .CK(CLK),
    .D(_0027_),
    .Q(\rxf_mem[1] [0]),
    .QN(_1254_)
  );
  DFF_X1 _2467_ (
    .CK(CLK),
    .D(_0026_),
    .Q(\rxf_mem[1] [1]),
    .QN(_1240_)
  );
  DFF_X1 _2468_ (
    .CK(CLK),
    .D(_0025_),
    .Q(\rxf_mem[1] [2]),
    .QN(_1241_)
  );
  DFF_X1 _2469_ (
    .CK(CLK),
    .D(_0024_),
    .Q(\rxf_mem[1] [3]),
    .QN(_1242_)
  );
  DFF_X1 _2470_ (
    .CK(CLK),
    .D(_0023_),
    .Q(\rxf_mem[1] [4]),
    .QN(_1243_)
  );
  DFF_X1 _2471_ (
    .CK(CLK),
    .D(_0022_),
    .Q(\rxf_mem[1] [5]),
    .QN(_1244_)
  );
  DFF_X1 _2472_ (
    .CK(CLK),
    .D(_0021_),
    .Q(\rxf_mem[1] [6]),
    .QN(_1245_)
  );
  DFF_X1 _2473_ (
    .CK(CLK),
    .D(_0297_),
    .Q(\rxf_mem[1] [7]),
    .QN(_0973_)
  );
  DFFS_X1 _2474_ (
    .CK(CLK),
    .D(_0302_),
    .Q(SOUT),
    .QN(_0968_),
    .SN(RSTN)
  );
  DFF_X1 _2475_ (
    .CK(CLK),
    .D(_0020_),
    .Q(\txf_mem[12] [0]),
    .QN(_1253_)
  );
  DFF_X1 _2476_ (
    .CK(CLK),
    .D(_0019_),
    .Q(\txf_mem[12] [1]),
    .QN(_1247_)
  );
  DFF_X1 _2477_ (
    .CK(CLK),
    .D(_0018_),
    .Q(\txf_mem[12] [2]),
    .QN(_1248_)
  );
  DFF_X1 _2478_ (
    .CK(CLK),
    .D(_0017_),
    .Q(\txf_mem[12] [3]),
    .QN(_1249_)
  );
  DFF_X1 _2479_ (
    .CK(CLK),
    .D(_0016_),
    .Q(\txf_mem[12] [4]),
    .QN(_1250_)
  );
  DFF_X1 _2480_ (
    .CK(CLK),
    .D(_0015_),
    .Q(\txf_mem[12] [5]),
    .QN(_1251_)
  );
  DFF_X1 _2481_ (
    .CK(CLK),
    .D(_0014_),
    .Q(\txf_mem[12] [6]),
    .QN(_1252_)
  );
  DFF_X1 _2482_ (
    .CK(CLK),
    .D(_0303_),
    .Q(\txf_mem[12] [7]),
    .QN(_0967_)
  );
  DFF_X1 _2483_ (
    .CK(CLK),
    .D(_0362_),
    .Q(\rxf_mem[5] [0]),
    .QN(_1279_)
  );
  DFF_X1 _2484_ (
    .CK(CLK),
    .D(_0361_),
    .Q(\rxf_mem[5] [1]),
    .QN(_0915_)
  );
  DFF_X1 _2485_ (
    .CK(CLK),
    .D(_0360_),
    .Q(\rxf_mem[5] [2]),
    .QN(_0916_)
  );
  DFF_X1 _2486_ (
    .CK(CLK),
    .D(_0358_),
    .Q(\rxf_mem[5] [3]),
    .QN(_0918_)
  );
  DFF_X1 _2487_ (
    .CK(CLK),
    .D(_0357_),
    .Q(\rxf_mem[5] [4]),
    .QN(_0919_)
  );
  DFF_X1 _2488_ (
    .CK(CLK),
    .D(_0356_),
    .Q(\rxf_mem[5] [5]),
    .QN(_0920_)
  );
  DFF_X1 _2489_ (
    .CK(CLK),
    .D(_0355_),
    .Q(\rxf_mem[5] [6]),
    .QN(_0921_)
  );
  DFF_X1 _2490_ (
    .CK(CLK),
    .D(_0305_),
    .Q(\rxf_mem[5] [7]),
    .QN(_1273_)
  );
  DFFR_X1 _2491_ (
    .CK(CLK),
    .D(_0354_),
    .Q(txf_rptr[0]),
    .QN(_0912_[0]),
    .RN(RSTN)
  );
  DFFR_X1 _2492_ (
    .CK(CLK),
    .D(_0353_),
    .Q(txf_rptr[1]),
    .QN(_0922_),
    .RN(RSTN)
  );
  DFFR_X1 _2493_ (
    .CK(CLK),
    .D(_0352_),
    .Q(txf_rptr[2]),
    .QN(_0923_),
    .RN(RSTN)
  );
  DFFR_X1 _2494_ (
    .CK(CLK),
    .D(_0351_),
    .Q(txf_rptr[3]),
    .QN(_0924_),
    .RN(RSTN)
  );
  DFFR_X1 _2495_ (
    .CK(CLK),
    .D(_0307_),
    .Q(txf_rptr[4]),
    .QN(_0963_),
    .RN(RSTN)
  );
  DFF_X1 _2496_ (
    .CK(CLK),
    .D(_0350_),
    .Q(\txf_mem[14] [0]),
    .QN(_1278_)
  );
  DFF_X1 _2497_ (
    .CK(CLK),
    .D(_0349_),
    .Q(\txf_mem[14] [1]),
    .QN(_0926_)
  );
  DFF_X1 _2498_ (
    .CK(CLK),
    .D(_0348_),
    .Q(\txf_mem[14] [2]),
    .QN(_0927_)
  );
  DFF_X1 _2499_ (
    .CK(CLK),
    .D(_0347_),
    .Q(\txf_mem[14] [3]),
    .QN(_0928_)
  );
  DFF_X1 _2500_ (
    .CK(CLK),
    .D(_0346_),
    .Q(\txf_mem[14] [4]),
    .QN(_0929_)
  );
  DFF_X1 _2501_ (
    .CK(CLK),
    .D(_0345_),
    .Q(\txf_mem[14] [5]),
    .QN(_0930_)
  );
  DFF_X1 _2502_ (
    .CK(CLK),
    .D(_0343_),
    .Q(\txf_mem[14] [6]),
    .QN(_0932_)
  );
  DFF_X1 _2503_ (
    .CK(CLK),
    .D(_0311_),
    .Q(\txf_mem[14] [7]),
    .QN(_0959_)
  );
  DFF_X1 _2504_ (
    .CK(CLK),
    .D(_0342_),
    .Q(\rxf_mem[14] [0]),
    .QN(_1277_)
  );
  DFF_X1 _2505_ (
    .CK(CLK),
    .D(_0341_),
    .Q(\rxf_mem[14] [1]),
    .QN(_0934_)
  );
  DFF_X1 _2506_ (
    .CK(CLK),
    .D(_0340_),
    .Q(\rxf_mem[14] [2]),
    .QN(_0935_)
  );
  DFF_X1 _2507_ (
    .CK(CLK),
    .D(_0339_),
    .Q(\rxf_mem[14] [3]),
    .QN(_0936_)
  );
  DFF_X1 _2508_ (
    .CK(CLK),
    .D(_0338_),
    .Q(\rxf_mem[14] [4]),
    .QN(_0937_)
  );
  DFF_X1 _2509_ (
    .CK(CLK),
    .D(_0337_),
    .Q(\rxf_mem[14] [5]),
    .QN(_0938_)
  );
  DFF_X1 _2510_ (
    .CK(CLK),
    .D(_0336_),
    .Q(\rxf_mem[14] [6]),
    .QN(_0939_)
  );
  DFF_X1 _2511_ (
    .CK(CLK),
    .D(_0315_),
    .Q(\rxf_mem[14] [7]),
    .QN(_0955_)
  );
  DFF_X1 _2512_ (
    .CK(CLK),
    .D(_0335_),
    .Q(\txf_mem[0] [0]),
    .QN(_1276_)
  );
  DFF_X1 _2513_ (
    .CK(CLK),
    .D(_0334_),
    .Q(\txf_mem[0] [1]),
    .QN(_0941_)
  );
  DFF_X1 _2514_ (
    .CK(CLK),
    .D(_0333_),
    .Q(\txf_mem[0] [2]),
    .QN(_1275_)
  );
  DFF_X1 _2515_ (
    .CK(CLK),
    .D(_0301_),
    .Q(\txf_mem[0] [3]),
    .QN(_0969_)
  );
  DFF_X1 _2516_ (
    .CK(CLK),
    .D(_0290_),
    .Q(\txf_mem[0] [4]),
    .QN(_0980_)
  );
  DFF_X1 _2517_ (
    .CK(CLK),
    .D(_0281_),
    .Q(\txf_mem[0] [5]),
    .QN(_0989_)
  );
  DFF_X1 _2518_ (
    .CK(CLK),
    .D(_0273_),
    .Q(\txf_mem[0] [6]),
    .QN(_0997_)
  );
  DFF_X1 _2519_ (
    .CK(CLK),
    .D(_0316_),
    .Q(\txf_mem[0] [7]),
    .QN(_0954_)
  );
  DFF_X1 _2520_ (
    .CK(CLK),
    .D(_0265_),
    .Q(\rxf_mem[2] [0]),
    .QN(_1272_)
  );
  DFF_X1 _2521_ (
    .CK(CLK),
    .D(_0257_),
    .Q(\rxf_mem[2] [1]),
    .QN(_1013_)
  );
  DFF_X1 _2522_ (
    .CK(CLK),
    .D(_0249_),
    .Q(\rxf_mem[2] [2]),
    .QN(_1021_)
  );
  DFF_X1 _2523_ (
    .CK(CLK),
    .D(_0241_),
    .Q(\rxf_mem[2] [3]),
    .QN(_1029_)
  );
  DFF_X1 _2524_ (
    .CK(CLK),
    .D(_0223_),
    .Q(\rxf_mem[2] [4]),
    .QN(_1047_)
  );
  DFF_X1 _2525_ (
    .CK(CLK),
    .D(_0213_),
    .Q(\rxf_mem[2] [5]),
    .QN(_1057_)
  );
  DFF_X1 _2526_ (
    .CK(CLK),
    .D(_0202_),
    .Q(\rxf_mem[2] [6]),
    .QN(_1068_)
  );
  DFF_X1 _2527_ (
    .CK(CLK),
    .D(_0320_),
    .Q(\rxf_mem[2] [7]),
    .QN(_0950_)
  );
  DFF_X1 _2528_ (
    .CK(CLK),
    .D(_0181_),
    .Q(\txf_mem[2] [0]),
    .QN(_1089_)
  );
  DFF_X1 _2529_ (
    .CK(CLK),
    .D(_0171_),
    .Q(\txf_mem[2] [1]),
    .QN(_1099_)
  );
  DFF_X1 _2530_ (
    .CK(CLK),
    .D(_0169_),
    .Q(\txf_mem[2] [2]),
    .QN(_1101_)
  );
  DFF_X1 _2531_ (
    .CK(CLK),
    .D(_0167_),
    .Q(\txf_mem[2] [3]),
    .QN(_1103_)
  );
  DFF_X1 _2532_ (
    .CK(CLK),
    .D(_0166_),
    .Q(\txf_mem[2] [4]),
    .QN(_1104_)
  );
  DFF_X1 _2533_ (
    .CK(CLK),
    .D(_0160_),
    .Q(\txf_mem[2] [5]),
    .QN(_1109_)
  );
  DFF_X1 _2534_ (
    .CK(CLK),
    .D(_0151_),
    .Q(\txf_mem[2] [6]),
    .QN(_1268_)
  );
  DFF_X1 _2535_ (
    .CK(CLK),
    .D(_0327_),
    .Q(\txf_mem[2] [7]),
    .QN(_0946_)
  );
  DFF_X1 _2536_ (
    .CK(CLK),
    .D(_0142_),
    .Q(\txf_mem[8] [0]),
    .QN(_1267_)
  );
  DFF_X1 _2537_ (
    .CK(CLK),
    .D(_0140_),
    .Q(\txf_mem[8] [1]),
    .QN(_1129_)
  );
  DFF_X1 _2538_ (
    .CK(CLK),
    .D(_0139_),
    .Q(\txf_mem[8] [2]),
    .QN(_1130_)
  );
  DFF_X1 _2539_ (
    .CK(CLK),
    .D(_0135_),
    .Q(\txf_mem[8] [3]),
    .QN(_1134_)
  );
  DFF_X1 _2540_ (
    .CK(CLK),
    .D(_0134_),
    .Q(\txf_mem[8] [4]),
    .QN(_1135_)
  );
  DFF_X1 _2541_ (
    .CK(CLK),
    .D(_0133_),
    .Q(\txf_mem[8] [5]),
    .QN(_1136_)
  );
  DFF_X1 _2542_ (
    .CK(CLK),
    .D(_0132_),
    .Q(\txf_mem[8] [6]),
    .QN(_1137_)
  );
  DFF_X1 _2543_ (
    .CK(CLK),
    .D(_0329_),
    .Q(\txf_mem[8] [7]),
    .QN(_0945_)
  );
  DFF_X1 _2544_ (
    .CK(CLK),
    .D(_0131_),
    .Q(\rxf_mem[10] [0]),
    .QN(_1266_)
  );
  DFF_X1 _2545_ (
    .CK(CLK),
    .D(_0128_),
    .Q(\rxf_mem[10] [1]),
    .QN(_1141_)
  );
  DFF_X1 _2546_ (
    .CK(CLK),
    .D(_0119_),
    .Q(\rxf_mem[10] [2]),
    .QN(_1150_)
  );
  DFF_X1 _2547_ (
    .CK(CLK),
    .D(_0107_),
    .Q(\rxf_mem[10] [3]),
    .QN(_1161_)
  );
  DFF_X1 _2548_ (
    .CK(CLK),
    .D(_0099_),
    .Q(\rxf_mem[10] [4]),
    .QN(_1169_)
  );
  DFF_X1 _2549_ (
    .CK(CLK),
    .D(_0087_),
    .Q(\rxf_mem[10] [5]),
    .QN(_1180_)
  );
  DFF_X1 _2550_ (
    .CK(CLK),
    .D(_0086_),
    .Q(\rxf_mem[10] [6]),
    .QN(_1181_)
  );
  DFF_X1 _2551_ (
    .CK(CLK),
    .D(_0344_),
    .Q(\rxf_mem[10] [7]),
    .QN(_0931_)
  );
  DFF_X1 _2552_ (
    .CK(CLK),
    .D(_0078_),
    .Q(\rxf_mem[3] [0]),
    .QN(_1189_)
  );
  DFF_X1 _2553_ (
    .CK(CLK),
    .D(_0077_),
    .Q(\rxf_mem[3] [1]),
    .QN(_1190_)
  );
  DFF_X1 _2554_ (
    .CK(CLK),
    .D(_0076_),
    .Q(\rxf_mem[3] [2]),
    .QN(_1264_)
  );
  DFF_X1 _2555_ (
    .CK(CLK),
    .D(_0075_),
    .Q(\rxf_mem[3] [3]),
    .QN(_1192_)
  );
  DFF_X1 _2556_ (
    .CK(CLK),
    .D(_0074_),
    .Q(\rxf_mem[3] [4]),
    .QN(_1193_)
  );
  DFF_X1 _2557_ (
    .CK(CLK),
    .D(_0073_),
    .Q(\rxf_mem[3] [5]),
    .QN(_1194_)
  );
  DFF_X1 _2558_ (
    .CK(CLK),
    .D(_0072_),
    .Q(\rxf_mem[3] [6]),
    .QN(_1195_)
  );
  DFF_X1 _2559_ (
    .CK(CLK),
    .D(_0359_),
    .Q(\rxf_mem[3] [7]),
    .QN(_0917_)
  );
  DFFS_X1 _2560_ (
    .CK(CLK),
    .D(_0007_),
    .Q(tx_state[0]),
    .QN(_1208_),
    .SN(RSTN)
  );
  DFFR_X1 _2561_ (
    .CK(CLK),
    .D(_0008_),
    .Q(tx_state[1]),
    .QN(_1215_),
    .RN(RSTN)
  );
  DFFR_X1 _2562_ (
    .CK(CLK),
    .D(_0009_),
    .Q(tx_state[2]),
    .QN(_1225_),
    .RN(RSTN)
  );
  DFFR_X1 _2563_ (
    .CK(CLK),
    .D(_0010_),
    .Q(tx_state[3]),
    .QN(_1191_),
    .RN(RSTN)
  );
  DFFS_X1 _2564_ (
    .CK(CLK),
    .D(_0003_),
    .Q(rx_state[0]),
    .QN(_0933_),
    .SN(RSTN)
  );
  DFFR_X1 _2565_ (
    .CK(CLK),
    .D(_0004_),
    .Q(rx_state[1]),
    .QN(_0940_),
    .RN(RSTN)
  );
  DFFR_X1 _2566_ (
    .CK(CLK),
    .D(_0005_),
    .Q(rx_state[2]),
    .QN(_1005_),
    .RN(RSTN)
  );
  DFFR_X1 _2567_ (
    .CK(CLK),
    .D(_0006_),
    .Q(rx_state[3]),
    .QN(_1118_),
    .RN(RSTN)
  );
  DFFR_X1 _2568_ (
    .CK(CLK),
    .D(_0002_),
    .Q(rx_push),
    .QN(_0013_),
    .RN(RSTN)
  );
  DFFS_X1 _2569_ (
    .CK(CLK),
    .D(SIN),
    .Q(sin_s1),
    .QN(_0947_),
    .SN(RSTN)
  );
  DFFS_X1 _2570_ (
    .CK(CLK),
    .D(sin_s1),
    .Q(sin_s2),
    .QN(_0965_),
    .SN(RSTN)
  );
  DFFS_X1 _2571_ (
    .CK(CLK),
    .D(_0000_[0]),
    .Q(baud_cnt[0]),
    .QN(_1138_),
    .SN(RSTN)
  );
  DFFR_X1 _2572_ (
    .CK(CLK),
    .D(_0000_[1]),
    .Q(baud_cnt[1]),
    .QN(_1182_),
    .RN(RSTN)
  );
  DFFR_X1 _2573_ (
    .CK(CLK),
    .D(_0000_[2]),
    .Q(baud_cnt[2]),
    .QN(_1196_),
    .RN(RSTN)
  );
  DFFR_X1 _2574_ (
    .CK(CLK),
    .D(_0000_[3]),
    .Q(baud_cnt[3]),
    .QN(_1263_),
    .RN(RSTN)
  );
  DFFR_X1 _2575_ (
    .CK(CLK),
    .D(_0000_[4]),
    .Q(baud_cnt[4]),
    .QN(_1198_),
    .RN(RSTN)
  );
  DFFR_X1 _2576_ (
    .CK(CLK),
    .D(_0000_[5]),
    .Q(baud_cnt[5]),
    .QN(_1261_),
    .RN(RSTN)
  );
  DFFR_X1 _2577_ (
    .CK(CLK),
    .D(_0000_[6]),
    .Q(baud_cnt[6]),
    .QN(_1260_),
    .RN(RSTN)
  );
  DFFR_X1 _2578_ (
    .CK(CLK),
    .D(_0000_[7]),
    .Q(baud_cnt[7]),
    .QN(_1201_),
    .RN(RSTN)
  );
  DFFR_X1 _2579_ (
    .CK(CLK),
    .D(_0000_[8]),
    .Q(baud_cnt[8]),
    .QN(_1232_),
    .RN(RSTN)
  );
  DFFR_X1 _2580_ (
    .CK(CLK),
    .D(_0000_[9]),
    .Q(baud_cnt[9]),
    .QN(_1239_),
    .RN(RSTN)
  );
  DFFR_X1 _2581_ (
    .CK(CLK),
    .D(_0000_[10]),
    .Q(baud_cnt[10]),
    .QN(_1246_),
    .RN(RSTN)
  );
  DFFR_X1 _2582_ (
    .CK(CLK),
    .D(_0000_[11]),
    .Q(baud_cnt[11]),
    .QN(_0914_),
    .RN(RSTN)
  );
  DFFR_X1 _2583_ (
    .CK(CLK),
    .D(_0000_[12]),
    .Q(baud_cnt[12]),
    .QN(_0925_),
    .RN(RSTN)
  );
  DFFR_X1 _2584_ (
    .CK(CLK),
    .D(_0000_[13]),
    .Q(baud_cnt[13]),
    .QN(_1078_),
    .RN(RSTN)
  );
  DFFR_X1 _2585_ (
    .CK(CLK),
    .D(_0000_[14]),
    .Q(baud_cnt[14]),
    .QN(_1127_),
    .RN(RSTN)
  );
  DFFR_X1 _2586_ (
    .CK(CLK),
    .D(_0000_[15]),
    .Q(baud_cnt[15]),
    .QN(_1070_),
    .RN(RSTN)
  );
  DFFR_X1 _2587_ (
    .CK(CLK),
    .D(_0001_),
    .Q(baud_tick),
    .QN(_1090_),
    .RN(RSTN)
  );
  assign _0910_[4:1] = rxf_rptr[4:1];
  assign _0911_[4:1] = rxf_wptr[4:1];
  assign _0912_[4:1] = txf_rptr[4:1];
  assign _0913_[4:1] = txf_wptr[4:1];
  assign baud_div = { dlm_r, dll_r };
  assign msr = { DCDN, RIN, DSRN, CTSN, 4'h0 };
  assign rx_byte_in = rx_shift;
  assign rxf_wen = rx_push;
  assign txf_empty = lsr[5];
  assign dlab = lcr_r[7];
  assign { lsr[6], lsr[4:1] } = { lsr[5], 3'h0, lsr_oe_r };
  assign PSLVERR = 1'h0;
  assign PREADY = 1'h1;
  assign PRDATA[31:8] = 24'h000000;
endmodule

module axil_to_apb(clk, rst_n, s_awaddr, s_awvalid, s_awready, s_wdata, s_wstrb, s_wvalid, s_wready, s_bresp, s_bvalid, s_bready, s_araddr, s_arvalid, s_arready, s_rdata, s_rresp, s_rvalid, s_rready, paddr, psel
, penable, pwrite, pwdata, prdata, pready, pslverr);
  input clk;
  wire clk;
  input rst_n;
  wire rst_n;
  input [11:0] s_awaddr;
  wire [11:0] s_awaddr;
  input s_awvalid;
  wire s_awvalid;
  output s_awready;
  wire s_awready;
  input [31:0] s_wdata;
  wire [31:0] s_wdata;
  input [3:0] s_wstrb;
  wire [3:0] s_wstrb;
  input s_wvalid;
  wire s_wvalid;
  output s_wready;
  wire s_wready;
  output [1:0] s_bresp;
  wire [1:0] s_bresp;
  output s_bvalid;
  wire s_bvalid;
  input s_bready;
  wire s_bready;
  input [11:0] s_araddr;
  wire [11:0] s_araddr;
  input s_arvalid;
  wire s_arvalid;
  output s_arready;
  wire s_arready;
  output [31:0] s_rdata;
  wire [31:0] s_rdata;
  output [1:0] s_rresp;
  wire [1:0] s_rresp;
  output s_rvalid;
  wire s_rvalid;
  input s_rready;
  wire s_rready;
  output [11:0] paddr;
  wire [11:0] paddr;
  output psel;
  wire psel;
  output penable;
  wire penable;
  output pwrite;
  wire pwrite;
  output [31:0] pwdata;
  wire [31:0] pwdata;
  input [31:0] prdata;
  wire [31:0] prdata;
  input pready;
  wire pready;
  input pslverr;
  wire pslverr;
  wire _000_;
  wire _001_;
  wire _002_;
  wire _003_;
  wire _004_;
  wire _005_;
  wire _006_;
  wire _007_;
  wire _008_;
  wire _009_;
  wire _010_;
  wire _011_;
  wire _012_;
  wire _013_;
  wire _014_;
  wire _015_;
  wire _016_;
  wire _017_;
  wire _018_;
  wire _019_;
  wire _020_;
  wire _021_;
  wire _022_;
  wire _023_;
  wire _024_;
  wire _025_;
  wire _026_;
  wire _027_;
  wire _028_;
  wire _029_;
  wire _030_;
  wire _031_;
  wire _032_;
  wire _033_;
  wire _034_;
  wire _035_;
  wire _036_;
  wire _037_;
  wire _038_;
  wire _039_;
  wire _040_;
  wire _041_;
  wire _042_;
  wire _043_;
  wire _044_;
  wire _045_;
  wire _046_;
  wire _047_;
  wire _048_;
  wire _049_;
  wire _050_;
  wire _051_;
  wire _052_;
  wire _053_;
  wire _054_;
  wire _055_;
  wire _056_;
  wire _057_;
  wire _058_;
  wire _059_;
  wire _060_;
  wire _061_;
  wire _062_;
  wire _063_;
  wire _064_;
  wire _065_;
  wire _066_;
  wire _067_;
  wire _068_;
  wire _069_;
  wire _070_;
  wire _071_;
  wire _072_;
  wire _073_;
  wire _074_;
  wire _075_;
  wire _076_;
  wire _077_;
  wire _078_;
  wire _079_;
  wire _080_;
  wire _081_;
  wire _082_;
  wire _083_;
  wire _084_;
  wire _085_;
  wire _086_;
  wire _087_;
  wire _088_;
  wire _089_;
  wire _090_;
  wire _091_;
  wire _092_;
  wire _093_;
  wire _094_;
  wire _095_;
  wire _096_;
  wire _097_;
  wire _098_;
  wire _099_;
  wire _100_;
  wire _101_;
  wire _102_;
  wire _103_;
  wire _104_;
  wire _105_;
  wire _106_;
  wire _107_;
  wire _108_;
  wire _109_;
  wire _110_;
  wire _111_;
  wire _112_;
  wire _113_;
  wire _114_;
  wire _115_;
  wire _116_;
  wire _117_;
  wire _118_;
  wire _119_;
  wire _120_;
  wire _121_;
  wire _122_;
  wire _123_;
  wire _124_;
  wire _125_;
  wire _126_;
  wire _127_;
  wire _128_;
  wire _129_;
  wire _130_;
  wire _131_;
  wire _132_;
  wire _133_;
  wire _134_;
  wire _135_;
  wire _136_;
  wire _137_;
  wire _138_;
  wire _139_;
  wire _140_;
  wire _141_;
  wire _142_;
  wire _143_;
  wire _144_;
  wire _145_;
  wire _146_;
  wire _147_;
  wire _148_;
  wire _149_;
  wire _150_;
  wire _151_;
  wire _152_;
  wire _153_;
  wire _154_;
  wire _155_;
  wire _156_;
  wire _157_;
  wire _158_;
  wire _159_;
  wire _160_;
  wire _161_;
  wire _162_;
  wire _163_;
  wire _164_;
  wire _165_;
  wire _166_;
  wire _167_;
  wire _168_;
  wire _169_;
  wire _170_;
  wire _171_;
  wire _172_;
  wire _173_;
  wire _174_;
  wire _175_;
  wire _176_;
  wire _177_;
  wire _178_;
  wire _179_;
  wire _180_;
  wire _181_;
  wire _182_;
  wire _183_;
  wire _184_;
  wire _185_;
  wire _186_;
  wire _187_;
  wire _188_;
  wire _189_;
  wire _190_;
  wire _191_;
  wire _192_;
  wire _193_;
  wire _194_;
  wire _195_;
  wire _196_;
  wire _197_;
  wire _198_;
  wire _199_;
  wire _200_;
  wire [11:0] lat_addr_r;
  wire [31:0] lat_wdata_r;
  wire lat_write_r;
  wire rd_pending_r;
  wire [31:0] rdata_r;
  wire slverr_r;
  wire [3:0] state_r;
  wire wr_pending_r;
  INV_X1 _201_ (
    .A(state_r[0]),
    .ZN(_084_)
  );
  INV_X1 _202_ (
    .A(rd_pending_r),
    .ZN(_085_)
  );
  INV_X1 _203_ (
    .A(state_r[2]),
    .ZN(_086_)
  );
  INV_X1 _204_ (
    .A(state_r[3]),
    .ZN(_087_)
  );
  INV_X1 _205_ (
    .A(s_bready),
    .ZN(_088_)
  );
  NAND2_X1 _206_ (
    .A1(s_awvalid),
    .A2(s_wvalid),
    .ZN(_089_)
  );
  AND3_X1 _207_ (
    .A1(state_r[0]),
    .A2(_085_),
    .A3(_089_),
    .ZN(s_arready)
  );
  OAI21_X1 _208_ (
    .A(state_r[0]),
    .B1(rd_pending_r),
    .B2(wr_pending_r),
    .ZN(_090_)
  );
  INV_X1 _209_ (
    .A(_090_),
    .ZN(_002_)
  );
  NOR2_X1 _210_ (
    .A1(state_r[1]),
    .A2(state_r[2]),
    .ZN(_091_)
  );
  INV_X1 _211_ (
    .A(_091_),
    .ZN(psel)
  );
  NAND2_X1 _212_ (
    .A1(lat_write_r),
    .A2(state_r[3]),
    .ZN(_092_)
  );
  INV_X1 _213_ (
    .A(_092_),
    .ZN(s_bvalid)
  );
  NOR2_X1 _214_ (
    .A1(lat_write_r),
    .A2(_087_),
    .ZN(s_rvalid)
  );
  NAND2_X1 _215_ (
    .A1(state_r[1]),
    .A2(pready),
    .ZN(_093_)
  );
  NOR2_X1 _216_ (
    .A1(s_bready),
    .A2(_092_),
    .ZN(_094_)
  );
  NOR3_X1 _217_ (
    .A1(lat_write_r),
    .A2(_087_),
    .A3(s_rready),
    .ZN(_095_)
  );
  NOR2_X1 _218_ (
    .A1(_094_),
    .A2(_095_),
    .ZN(_096_)
  );
  NAND2_X1 _219_ (
    .A1(_093_),
    .A2(_096_),
    .ZN(_005_)
  );
  AOI21_X1 _220_ (
    .A(_091_),
    .B1(_086_),
    .B2(pready),
    .ZN(_004_)
  );
  NOR2_X1 _221_ (
    .A1(_084_),
    .A2(wr_pending_r),
    .ZN(s_awready)
  );
  AOI22_X1 _222_ (
    .A1(s_rready),
    .A2(s_rvalid),
    .B1(s_awready),
    .B2(_085_),
    .ZN(_097_)
  );
  OAI21_X1 _223_ (
    .A(_097_),
    .B1(_092_),
    .B2(_088_),
    .ZN(_003_)
  );
  NOR3_X1 _224_ (
    .A1(_084_),
    .A2(wr_pending_r),
    .A3(_089_),
    .ZN(_098_)
  );
  NOR2_X1 _225_ (
    .A1(wr_pending_r),
    .A2(_098_),
    .ZN(_099_)
  );
  NOR2_X1 _226_ (
    .A1(wr_pending_r),
    .A2(lat_write_r),
    .ZN(_100_)
  );
  OR2_X1 _227_ (
    .A1(wr_pending_r),
    .A2(lat_write_r),
    .ZN(_101_)
  );
  NOR4_X1 _228_ (
    .A1(_090_),
    .A2(psel),
    .A3(_094_),
    .A4(_095_),
    .ZN(_102_)
  );
  AOI21_X1 _229_ (
    .A(_099_),
    .B1(_101_),
    .B2(_102_),
    .ZN(_001_)
  );
  NAND4_X1 _230_ (
    .A1(state_r[0]),
    .A2(_085_),
    .A3(s_arvalid),
    .A4(_089_),
    .ZN(_103_)
  );
  AOI22_X1 _231_ (
    .A1(_100_),
    .A2(_102_),
    .B1(_103_),
    .B2(_085_),
    .ZN(_000_)
  );
  MUX2_X1 _232_ (
    .A(prdata[25]),
    .B(rdata_r[25]),
    .S(_093_),
    .Z(_006_)
  );
  MUX2_X1 _233_ (
    .A(prdata[24]),
    .B(rdata_r[24]),
    .S(_093_),
    .Z(_007_)
  );
  MUX2_X1 _234_ (
    .A(prdata[23]),
    .B(rdata_r[23]),
    .S(_093_),
    .Z(_008_)
  );
  MUX2_X1 _235_ (
    .A(prdata[22]),
    .B(rdata_r[22]),
    .S(_093_),
    .Z(_009_)
  );
  MUX2_X1 _236_ (
    .A(prdata[21]),
    .B(rdata_r[21]),
    .S(_093_),
    .Z(_010_)
  );
  MUX2_X1 _237_ (
    .A(prdata[20]),
    .B(rdata_r[20]),
    .S(_093_),
    .Z(_011_)
  );
  MUX2_X1 _238_ (
    .A(prdata[19]),
    .B(rdata_r[19]),
    .S(_093_),
    .Z(_012_)
  );
  MUX2_X1 _239_ (
    .A(prdata[18]),
    .B(rdata_r[18]),
    .S(_093_),
    .Z(_013_)
  );
  MUX2_X1 _240_ (
    .A(prdata[17]),
    .B(rdata_r[17]),
    .S(_093_),
    .Z(_014_)
  );
  MUX2_X1 _241_ (
    .A(prdata[16]),
    .B(rdata_r[16]),
    .S(_093_),
    .Z(_015_)
  );
  MUX2_X1 _242_ (
    .A(prdata[15]),
    .B(rdata_r[15]),
    .S(_093_),
    .Z(_016_)
  );
  MUX2_X1 _243_ (
    .A(prdata[14]),
    .B(rdata_r[14]),
    .S(_093_),
    .Z(_017_)
  );
  MUX2_X1 _244_ (
    .A(prdata[13]),
    .B(rdata_r[13]),
    .S(_093_),
    .Z(_018_)
  );
  MUX2_X1 _245_ (
    .A(prdata[12]),
    .B(rdata_r[12]),
    .S(_093_),
    .Z(_019_)
  );
  MUX2_X1 _246_ (
    .A(prdata[11]),
    .B(rdata_r[11]),
    .S(_093_),
    .Z(_020_)
  );
  MUX2_X1 _247_ (
    .A(prdata[10]),
    .B(rdata_r[10]),
    .S(_093_),
    .Z(_021_)
  );
  MUX2_X1 _248_ (
    .A(prdata[9]),
    .B(rdata_r[9]),
    .S(_093_),
    .Z(_022_)
  );
  MUX2_X1 _249_ (
    .A(prdata[8]),
    .B(rdata_r[8]),
    .S(_093_),
    .Z(_023_)
  );
  MUX2_X1 _250_ (
    .A(prdata[7]),
    .B(rdata_r[7]),
    .S(_093_),
    .Z(_024_)
  );
  MUX2_X1 _251_ (
    .A(prdata[6]),
    .B(rdata_r[6]),
    .S(_093_),
    .Z(_025_)
  );
  MUX2_X1 _252_ (
    .A(prdata[5]),
    .B(rdata_r[5]),
    .S(_093_),
    .Z(_026_)
  );
  MUX2_X1 _253_ (
    .A(prdata[4]),
    .B(rdata_r[4]),
    .S(_093_),
    .Z(_027_)
  );
  MUX2_X1 _254_ (
    .A(prdata[3]),
    .B(rdata_r[3]),
    .S(_093_),
    .Z(_028_)
  );
  MUX2_X1 _255_ (
    .A(prdata[2]),
    .B(rdata_r[2]),
    .S(_093_),
    .Z(_029_)
  );
  MUX2_X1 _256_ (
    .A(prdata[1]),
    .B(rdata_r[1]),
    .S(_093_),
    .Z(_030_)
  );
  MUX2_X1 _257_ (
    .A(prdata[0]),
    .B(rdata_r[0]),
    .S(_093_),
    .Z(_031_)
  );
  MUX2_X1 _258_ (
    .A(lat_wdata_r[30]),
    .B(s_wdata[30]),
    .S(_098_),
    .Z(_032_)
  );
  MUX2_X1 _259_ (
    .A(lat_wdata_r[29]),
    .B(s_wdata[29]),
    .S(_098_),
    .Z(_033_)
  );
  MUX2_X1 _260_ (
    .A(lat_wdata_r[28]),
    .B(s_wdata[28]),
    .S(_098_),
    .Z(_034_)
  );
  MUX2_X1 _261_ (
    .A(lat_wdata_r[27]),
    .B(s_wdata[27]),
    .S(_098_),
    .Z(_035_)
  );
  MUX2_X1 _262_ (
    .A(lat_wdata_r[26]),
    .B(s_wdata[26]),
    .S(_098_),
    .Z(_036_)
  );
  MUX2_X1 _263_ (
    .A(lat_wdata_r[25]),
    .B(s_wdata[25]),
    .S(_098_),
    .Z(_037_)
  );
  MUX2_X1 _264_ (
    .A(lat_wdata_r[24]),
    .B(s_wdata[24]),
    .S(_098_),
    .Z(_038_)
  );
  MUX2_X1 _265_ (
    .A(lat_wdata_r[23]),
    .B(s_wdata[23]),
    .S(_098_),
    .Z(_039_)
  );
  MUX2_X1 _266_ (
    .A(lat_wdata_r[22]),
    .B(s_wdata[22]),
    .S(_098_),
    .Z(_040_)
  );
  MUX2_X1 _267_ (
    .A(prdata[31]),
    .B(rdata_r[31]),
    .S(_093_),
    .Z(_041_)
  );
  MUX2_X1 _268_ (
    .A(lat_wdata_r[21]),
    .B(s_wdata[21]),
    .S(_098_),
    .Z(_042_)
  );
  MUX2_X1 _269_ (
    .A(lat_wdata_r[20]),
    .B(s_wdata[20]),
    .S(_098_),
    .Z(_043_)
  );
  MUX2_X1 _270_ (
    .A(lat_wdata_r[19]),
    .B(s_wdata[19]),
    .S(_098_),
    .Z(_044_)
  );
  MUX2_X1 _271_ (
    .A(lat_wdata_r[18]),
    .B(s_wdata[18]),
    .S(_098_),
    .Z(_045_)
  );
  MUX2_X1 _272_ (
    .A(lat_wdata_r[17]),
    .B(s_wdata[17]),
    .S(_098_),
    .Z(_046_)
  );
  MUX2_X1 _273_ (
    .A(lat_wdata_r[16]),
    .B(s_wdata[16]),
    .S(_098_),
    .Z(_047_)
  );
  MUX2_X1 _274_ (
    .A(lat_wdata_r[15]),
    .B(s_wdata[15]),
    .S(_098_),
    .Z(_048_)
  );
  MUX2_X1 _275_ (
    .A(pslverr),
    .B(slverr_r),
    .S(_093_),
    .Z(_049_)
  );
  MUX2_X1 _276_ (
    .A(lat_wdata_r[14]),
    .B(s_wdata[14]),
    .S(_098_),
    .Z(_050_)
  );
  MUX2_X1 _277_ (
    .A(lat_wdata_r[13]),
    .B(s_wdata[13]),
    .S(_098_),
    .Z(_051_)
  );
  MUX2_X1 _278_ (
    .A(lat_wdata_r[12]),
    .B(s_wdata[12]),
    .S(_098_),
    .Z(_052_)
  );
  MUX2_X1 _279_ (
    .A(lat_wdata_r[11]),
    .B(s_wdata[11]),
    .S(_098_),
    .Z(_053_)
  );
  MUX2_X1 _280_ (
    .A(lat_wdata_r[10]),
    .B(s_wdata[10]),
    .S(_098_),
    .Z(_054_)
  );
  MUX2_X1 _281_ (
    .A(lat_wdata_r[9]),
    .B(s_wdata[9]),
    .S(_098_),
    .Z(_055_)
  );
  MUX2_X1 _282_ (
    .A(lat_wdata_r[8]),
    .B(s_wdata[8]),
    .S(_098_),
    .Z(_056_)
  );
  MUX2_X1 _283_ (
    .A(lat_wdata_r[7]),
    .B(s_wdata[7]),
    .S(_098_),
    .Z(_057_)
  );
  MUX2_X1 _284_ (
    .A(lat_wdata_r[6]),
    .B(s_wdata[6]),
    .S(_098_),
    .Z(_058_)
  );
  MUX2_X1 _285_ (
    .A(lat_addr_r[11]),
    .B(s_awaddr[11]),
    .S(_098_),
    .Z(_104_)
  );
  MUX2_X1 _286_ (
    .A(s_araddr[11]),
    .B(_104_),
    .S(_103_),
    .Z(_059_)
  );
  AOI21_X1 _287_ (
    .A(_098_),
    .B1(_103_),
    .B2(lat_write_r),
    .ZN(_105_)
  );
  INV_X1 _288_ (
    .A(_105_),
    .ZN(_060_)
  );
  MUX2_X1 _289_ (
    .A(lat_wdata_r[5]),
    .B(s_wdata[5]),
    .S(_098_),
    .Z(_061_)
  );
  MUX2_X1 _290_ (
    .A(lat_wdata_r[4]),
    .B(s_wdata[4]),
    .S(_098_),
    .Z(_062_)
  );
  MUX2_X1 _291_ (
    .A(lat_wdata_r[3]),
    .B(s_wdata[3]),
    .S(_098_),
    .Z(_063_)
  );
  MUX2_X1 _292_ (
    .A(lat_wdata_r[2]),
    .B(s_wdata[2]),
    .S(_098_),
    .Z(_064_)
  );
  MUX2_X1 _293_ (
    .A(lat_wdata_r[1]),
    .B(s_wdata[1]),
    .S(_098_),
    .Z(_065_)
  );
  MUX2_X1 _294_ (
    .A(lat_wdata_r[0]),
    .B(s_wdata[0]),
    .S(_098_),
    .Z(_066_)
  );
  MUX2_X1 _295_ (
    .A(lat_addr_r[10]),
    .B(s_awaddr[10]),
    .S(_098_),
    .Z(_106_)
  );
  MUX2_X1 _296_ (
    .A(s_araddr[10]),
    .B(_106_),
    .S(_103_),
    .Z(_067_)
  );
  MUX2_X1 _297_ (
    .A(lat_addr_r[9]),
    .B(s_awaddr[9]),
    .S(_098_),
    .Z(_107_)
  );
  MUX2_X1 _298_ (
    .A(s_araddr[9]),
    .B(_107_),
    .S(_103_),
    .Z(_068_)
  );
  MUX2_X1 _299_ (
    .A(lat_wdata_r[31]),
    .B(s_wdata[31]),
    .S(_098_),
    .Z(_069_)
  );
  MUX2_X1 _300_ (
    .A(lat_addr_r[8]),
    .B(s_awaddr[8]),
    .S(_098_),
    .Z(_108_)
  );
  MUX2_X1 _301_ (
    .A(s_araddr[8]),
    .B(_108_),
    .S(_103_),
    .Z(_070_)
  );
  MUX2_X1 _302_ (
    .A(lat_addr_r[7]),
    .B(s_awaddr[7]),
    .S(_098_),
    .Z(_109_)
  );
  MUX2_X1 _303_ (
    .A(s_araddr[7]),
    .B(_109_),
    .S(_103_),
    .Z(_071_)
  );
  MUX2_X1 _304_ (
    .A(lat_addr_r[6]),
    .B(s_awaddr[6]),
    .S(_098_),
    .Z(_110_)
  );
  MUX2_X1 _305_ (
    .A(s_araddr[6]),
    .B(_110_),
    .S(_103_),
    .Z(_072_)
  );
  MUX2_X1 _306_ (
    .A(lat_addr_r[5]),
    .B(s_awaddr[5]),
    .S(_098_),
    .Z(_111_)
  );
  MUX2_X1 _307_ (
    .A(s_araddr[5]),
    .B(_111_),
    .S(_103_),
    .Z(_073_)
  );
  MUX2_X1 _308_ (
    .A(lat_addr_r[4]),
    .B(s_awaddr[4]),
    .S(_098_),
    .Z(_112_)
  );
  MUX2_X1 _309_ (
    .A(s_araddr[4]),
    .B(_112_),
    .S(_103_),
    .Z(_074_)
  );
  MUX2_X1 _310_ (
    .A(lat_addr_r[3]),
    .B(s_awaddr[3]),
    .S(_098_),
    .Z(_113_)
  );
  MUX2_X1 _311_ (
    .A(s_araddr[3]),
    .B(_113_),
    .S(_103_),
    .Z(_075_)
  );
  MUX2_X1 _312_ (
    .A(lat_addr_r[2]),
    .B(s_awaddr[2]),
    .S(_098_),
    .Z(_114_)
  );
  MUX2_X1 _313_ (
    .A(s_araddr[2]),
    .B(_114_),
    .S(_103_),
    .Z(_076_)
  );
  MUX2_X1 _314_ (
    .A(lat_addr_r[1]),
    .B(s_awaddr[1]),
    .S(_098_),
    .Z(_115_)
  );
  MUX2_X1 _315_ (
    .A(s_araddr[1]),
    .B(_115_),
    .S(_103_),
    .Z(_077_)
  );
  MUX2_X1 _316_ (
    .A(lat_addr_r[0]),
    .B(s_awaddr[0]),
    .S(_098_),
    .Z(_116_)
  );
  MUX2_X1 _317_ (
    .A(s_araddr[0]),
    .B(_116_),
    .S(_103_),
    .Z(_078_)
  );
  MUX2_X1 _318_ (
    .A(prdata[30]),
    .B(rdata_r[30]),
    .S(_093_),
    .Z(_079_)
  );
  MUX2_X1 _319_ (
    .A(prdata[29]),
    .B(rdata_r[29]),
    .S(_093_),
    .Z(_080_)
  );
  MUX2_X1 _320_ (
    .A(prdata[28]),
    .B(rdata_r[28]),
    .S(_093_),
    .Z(_081_)
  );
  MUX2_X1 _321_ (
    .A(prdata[27]),
    .B(rdata_r[27]),
    .S(_093_),
    .Z(_082_)
  );
  MUX2_X1 _322_ (
    .A(prdata[26]),
    .B(rdata_r[26]),
    .S(_093_),
    .Z(_083_)
  );
  DFFR_X1 _323_ (
    .CK(clk),
    .D(_031_),
    .Q(rdata_r[0]),
    .QN(_195_),
    .RN(rst_n)
  );
  DFFR_X1 _324_ (
    .CK(clk),
    .D(_030_),
    .Q(rdata_r[1]),
    .QN(_170_),
    .RN(rst_n)
  );
  DFFR_X1 _325_ (
    .CK(clk),
    .D(_029_),
    .Q(rdata_r[2]),
    .QN(_171_),
    .RN(rst_n)
  );
  DFFR_X1 _326_ (
    .CK(clk),
    .D(_028_),
    .Q(rdata_r[3]),
    .QN(_172_),
    .RN(rst_n)
  );
  DFFR_X1 _327_ (
    .CK(clk),
    .D(_027_),
    .Q(rdata_r[4]),
    .QN(_173_),
    .RN(rst_n)
  );
  DFFR_X1 _328_ (
    .CK(clk),
    .D(_026_),
    .Q(rdata_r[5]),
    .QN(_174_),
    .RN(rst_n)
  );
  DFFR_X1 _329_ (
    .CK(clk),
    .D(_025_),
    .Q(rdata_r[6]),
    .QN(_175_),
    .RN(rst_n)
  );
  DFFR_X1 _330_ (
    .CK(clk),
    .D(_024_),
    .Q(rdata_r[7]),
    .QN(_176_),
    .RN(rst_n)
  );
  DFFR_X1 _331_ (
    .CK(clk),
    .D(_023_),
    .Q(rdata_r[8]),
    .QN(_177_),
    .RN(rst_n)
  );
  DFFR_X1 _332_ (
    .CK(clk),
    .D(_022_),
    .Q(rdata_r[9]),
    .QN(_178_),
    .RN(rst_n)
  );
  DFFR_X1 _333_ (
    .CK(clk),
    .D(_021_),
    .Q(rdata_r[10]),
    .QN(_179_),
    .RN(rst_n)
  );
  DFFR_X1 _334_ (
    .CK(clk),
    .D(_020_),
    .Q(rdata_r[11]),
    .QN(_180_),
    .RN(rst_n)
  );
  DFFR_X1 _335_ (
    .CK(clk),
    .D(_019_),
    .Q(rdata_r[12]),
    .QN(_181_),
    .RN(rst_n)
  );
  DFFR_X1 _336_ (
    .CK(clk),
    .D(_018_),
    .Q(rdata_r[13]),
    .QN(_182_),
    .RN(rst_n)
  );
  DFFR_X1 _337_ (
    .CK(clk),
    .D(_017_),
    .Q(rdata_r[14]),
    .QN(_183_),
    .RN(rst_n)
  );
  DFFR_X1 _338_ (
    .CK(clk),
    .D(_016_),
    .Q(rdata_r[15]),
    .QN(_184_),
    .RN(rst_n)
  );
  DFFR_X1 _339_ (
    .CK(clk),
    .D(_015_),
    .Q(rdata_r[16]),
    .QN(_185_),
    .RN(rst_n)
  );
  DFFR_X1 _340_ (
    .CK(clk),
    .D(_014_),
    .Q(rdata_r[17]),
    .QN(_186_),
    .RN(rst_n)
  );
  DFFR_X1 _341_ (
    .CK(clk),
    .D(_013_),
    .Q(rdata_r[18]),
    .QN(_187_),
    .RN(rst_n)
  );
  DFFR_X1 _342_ (
    .CK(clk),
    .D(_012_),
    .Q(rdata_r[19]),
    .QN(_188_),
    .RN(rst_n)
  );
  DFFR_X1 _343_ (
    .CK(clk),
    .D(_011_),
    .Q(rdata_r[20]),
    .QN(_189_),
    .RN(rst_n)
  );
  DFFR_X1 _344_ (
    .CK(clk),
    .D(_010_),
    .Q(rdata_r[21]),
    .QN(_190_),
    .RN(rst_n)
  );
  DFFR_X1 _345_ (
    .CK(clk),
    .D(_009_),
    .Q(rdata_r[22]),
    .QN(_191_),
    .RN(rst_n)
  );
  DFFR_X1 _346_ (
    .CK(clk),
    .D(_008_),
    .Q(rdata_r[23]),
    .QN(_192_),
    .RN(rst_n)
  );
  DFFR_X1 _347_ (
    .CK(clk),
    .D(_007_),
    .Q(rdata_r[24]),
    .QN(_193_),
    .RN(rst_n)
  );
  DFFR_X1 _348_ (
    .CK(clk),
    .D(_006_),
    .Q(rdata_r[25]),
    .QN(_194_),
    .RN(rst_n)
  );
  DFFR_X1 _349_ (
    .CK(clk),
    .D(_083_),
    .Q(rdata_r[26]),
    .QN(_117_),
    .RN(rst_n)
  );
  DFFR_X1 _350_ (
    .CK(clk),
    .D(_082_),
    .Q(rdata_r[27]),
    .QN(_118_),
    .RN(rst_n)
  );
  DFFR_X1 _351_ (
    .CK(clk),
    .D(_081_),
    .Q(rdata_r[28]),
    .QN(_119_),
    .RN(rst_n)
  );
  DFFR_X1 _352_ (
    .CK(clk),
    .D(_080_),
    .Q(rdata_r[29]),
    .QN(_120_),
    .RN(rst_n)
  );
  DFFR_X1 _353_ (
    .CK(clk),
    .D(_079_),
    .Q(rdata_r[30]),
    .QN(_121_),
    .RN(rst_n)
  );
  DFFR_X1 _354_ (
    .CK(clk),
    .D(_041_),
    .Q(rdata_r[31]),
    .QN(_159_),
    .RN(rst_n)
  );
  DFFR_X1 _355_ (
    .CK(clk),
    .D(_049_),
    .Q(slverr_r),
    .QN(_151_),
    .RN(rst_n)
  );
  DFFR_X1 _356_ (
    .CK(clk),
    .D(_078_),
    .Q(lat_addr_r[0]),
    .QN(_200_),
    .RN(rst_n)
  );
  DFFR_X1 _357_ (
    .CK(clk),
    .D(_077_),
    .Q(lat_addr_r[1]),
    .QN(_123_),
    .RN(rst_n)
  );
  DFFR_X1 _358_ (
    .CK(clk),
    .D(_076_),
    .Q(lat_addr_r[2]),
    .QN(_124_),
    .RN(rst_n)
  );
  DFFR_X1 _359_ (
    .CK(clk),
    .D(_075_),
    .Q(lat_addr_r[3]),
    .QN(_125_),
    .RN(rst_n)
  );
  DFFR_X1 _360_ (
    .CK(clk),
    .D(_074_),
    .Q(lat_addr_r[4]),
    .QN(_126_),
    .RN(rst_n)
  );
  DFFR_X1 _361_ (
    .CK(clk),
    .D(_073_),
    .Q(lat_addr_r[5]),
    .QN(_127_),
    .RN(rst_n)
  );
  DFFR_X1 _362_ (
    .CK(clk),
    .D(_072_),
    .Q(lat_addr_r[6]),
    .QN(_128_),
    .RN(rst_n)
  );
  DFFR_X1 _363_ (
    .CK(clk),
    .D(_071_),
    .Q(lat_addr_r[7]),
    .QN(_129_),
    .RN(rst_n)
  );
  DFFR_X1 _364_ (
    .CK(clk),
    .D(_070_),
    .Q(lat_addr_r[8]),
    .QN(_130_),
    .RN(rst_n)
  );
  DFFR_X1 _365_ (
    .CK(clk),
    .D(_068_),
    .Q(lat_addr_r[9]),
    .QN(_132_),
    .RN(rst_n)
  );
  DFFR_X1 _366_ (
    .CK(clk),
    .D(_067_),
    .Q(lat_addr_r[10]),
    .QN(_133_),
    .RN(rst_n)
  );
  DFFR_X1 _367_ (
    .CK(clk),
    .D(_059_),
    .Q(lat_addr_r[11]),
    .QN(_141_),
    .RN(rst_n)
  );
  DFFR_X1 _368_ (
    .CK(clk),
    .D(_060_),
    .Q(lat_write_r),
    .QN(_140_),
    .RN(rst_n)
  );
  DFFR_X1 _369_ (
    .CK(clk),
    .D(_066_),
    .Q(lat_wdata_r[0]),
    .QN(_134_),
    .RN(rst_n)
  );
  DFFR_X1 _370_ (
    .CK(clk),
    .D(_065_),
    .Q(lat_wdata_r[1]),
    .QN(_135_),
    .RN(rst_n)
  );
  DFFR_X1 _371_ (
    .CK(clk),
    .D(_064_),
    .Q(lat_wdata_r[2]),
    .QN(_136_),
    .RN(rst_n)
  );
  DFFR_X1 _372_ (
    .CK(clk),
    .D(_063_),
    .Q(lat_wdata_r[3]),
    .QN(_137_),
    .RN(rst_n)
  );
  DFFR_X1 _373_ (
    .CK(clk),
    .D(_062_),
    .Q(lat_wdata_r[4]),
    .QN(_138_),
    .RN(rst_n)
  );
  DFFR_X1 _374_ (
    .CK(clk),
    .D(_061_),
    .Q(lat_wdata_r[5]),
    .QN(_139_),
    .RN(rst_n)
  );
  DFFR_X1 _375_ (
    .CK(clk),
    .D(_058_),
    .Q(lat_wdata_r[6]),
    .QN(_142_),
    .RN(rst_n)
  );
  DFFR_X1 _376_ (
    .CK(clk),
    .D(_057_),
    .Q(lat_wdata_r[7]),
    .QN(_143_),
    .RN(rst_n)
  );
  DFFR_X1 _377_ (
    .CK(clk),
    .D(_056_),
    .Q(lat_wdata_r[8]),
    .QN(_144_),
    .RN(rst_n)
  );
  DFFR_X1 _378_ (
    .CK(clk),
    .D(_055_),
    .Q(lat_wdata_r[9]),
    .QN(_145_),
    .RN(rst_n)
  );
  DFFR_X1 _379_ (
    .CK(clk),
    .D(_054_),
    .Q(lat_wdata_r[10]),
    .QN(_146_),
    .RN(rst_n)
  );
  DFFR_X1 _380_ (
    .CK(clk),
    .D(_053_),
    .Q(lat_wdata_r[11]),
    .QN(_147_),
    .RN(rst_n)
  );
  DFFR_X1 _381_ (
    .CK(clk),
    .D(_052_),
    .Q(lat_wdata_r[12]),
    .QN(_148_),
    .RN(rst_n)
  );
  DFFR_X1 _382_ (
    .CK(clk),
    .D(_051_),
    .Q(lat_wdata_r[13]),
    .QN(_149_),
    .RN(rst_n)
  );
  DFFR_X1 _383_ (
    .CK(clk),
    .D(_050_),
    .Q(lat_wdata_r[14]),
    .QN(_150_),
    .RN(rst_n)
  );
  DFFR_X1 _384_ (
    .CK(clk),
    .D(_048_),
    .Q(lat_wdata_r[15]),
    .QN(_152_),
    .RN(rst_n)
  );
  DFFR_X1 _385_ (
    .CK(clk),
    .D(_047_),
    .Q(lat_wdata_r[16]),
    .QN(_153_),
    .RN(rst_n)
  );
  DFFR_X1 _386_ (
    .CK(clk),
    .D(_046_),
    .Q(lat_wdata_r[17]),
    .QN(_154_),
    .RN(rst_n)
  );
  DFFR_X1 _387_ (
    .CK(clk),
    .D(_045_),
    .Q(lat_wdata_r[18]),
    .QN(_155_),
    .RN(rst_n)
  );
  DFFR_X1 _388_ (
    .CK(clk),
    .D(_044_),
    .Q(lat_wdata_r[19]),
    .QN(_156_),
    .RN(rst_n)
  );
  DFFR_X1 _389_ (
    .CK(clk),
    .D(_043_),
    .Q(lat_wdata_r[20]),
    .QN(_157_),
    .RN(rst_n)
  );
  DFFR_X1 _390_ (
    .CK(clk),
    .D(_042_),
    .Q(lat_wdata_r[21]),
    .QN(_158_),
    .RN(rst_n)
  );
  DFFR_X1 _391_ (
    .CK(clk),
    .D(_040_),
    .Q(lat_wdata_r[22]),
    .QN(_160_),
    .RN(rst_n)
  );
  DFFR_X1 _392_ (
    .CK(clk),
    .D(_039_),
    .Q(lat_wdata_r[23]),
    .QN(_198_),
    .RN(rst_n)
  );
  DFFR_X1 _393_ (
    .CK(clk),
    .D(_038_),
    .Q(lat_wdata_r[24]),
    .QN(_162_),
    .RN(rst_n)
  );
  DFFR_X1 _394_ (
    .CK(clk),
    .D(_037_),
    .Q(lat_wdata_r[25]),
    .QN(_163_),
    .RN(rst_n)
  );
  DFFR_X1 _395_ (
    .CK(clk),
    .D(_036_),
    .Q(lat_wdata_r[26]),
    .QN(_164_),
    .RN(rst_n)
  );
  DFFR_X1 _396_ (
    .CK(clk),
    .D(_035_),
    .Q(lat_wdata_r[27]),
    .QN(_165_),
    .RN(rst_n)
  );
  DFFR_X1 _397_ (
    .CK(clk),
    .D(_034_),
    .Q(lat_wdata_r[28]),
    .QN(_166_),
    .RN(rst_n)
  );
  DFFR_X1 _398_ (
    .CK(clk),
    .D(_033_),
    .Q(lat_wdata_r[29]),
    .QN(_167_),
    .RN(rst_n)
  );
  DFFR_X1 _399_ (
    .CK(clk),
    .D(_032_),
    .Q(lat_wdata_r[30]),
    .QN(_168_),
    .RN(rst_n)
  );
  DFFR_X1 _400_ (
    .CK(clk),
    .D(_069_),
    .Q(lat_wdata_r[31]),
    .QN(_131_),
    .RN(rst_n)
  );
  DFFS_X1 _401_ (
    .CK(clk),
    .D(_003_),
    .Q(state_r[0]),
    .QN(_197_),
    .SN(rst_n)
  );
  DFFR_X1 _402_ (
    .CK(clk),
    .D(_004_),
    .Q(state_r[1]),
    .QN(_196_),
    .RN(rst_n)
  );
  DFFR_X1 _403_ (
    .CK(clk),
    .D(_002_),
    .Q(state_r[2]),
    .QN(_169_),
    .RN(rst_n)
  );
  DFFR_X1 _404_ (
    .CK(clk),
    .D(_005_),
    .Q(state_r[3]),
    .QN(_199_),
    .RN(rst_n)
  );
  DFFR_X1 _405_ (
    .CK(clk),
    .D(_001_),
    .Q(wr_pending_r),
    .QN(_161_),
    .RN(rst_n)
  );
  DFFR_X1 _406_ (
    .CK(clk),
    .D(_000_),
    .Q(rd_pending_r),
    .QN(_122_),
    .RN(rst_n)
  );
  assign pwdata = lat_wdata_r;
  assign pwrite = lat_write_r;
  assign penable = state_r[1];
  assign paddr = lat_addr_r;
  assign s_rresp = { slverr_r, 1'h0 };
  assign s_rdata = rdata_r;
  assign s_bresp = { slverr_r, 1'h0 };
  assign s_wready = s_awready;
endmodule

module pulp_uart_wrap(clk, rst_n, secure_mode, s_awaddr, s_awvalid, s_awready, s_wdata, s_wstrb, s_wvalid, s_wready, s_bresp, s_bvalid, s_bready, s_araddr, s_arvalid, s_arready, s_rdata, s_rresp, s_rvalid, s_rready, uart_rx
, uart_tx, irq);
  input clk;
  wire clk;
  input rst_n;
  wire rst_n;
  input secure_mode;
  wire secure_mode;
  input [11:0] s_awaddr;
  wire [11:0] s_awaddr;
  input s_awvalid;
  wire s_awvalid;
  output s_awready;
  wire s_awready;
  input [31:0] s_wdata;
  wire [31:0] s_wdata;
  input [3:0] s_wstrb;
  wire [3:0] s_wstrb;
  input s_wvalid;
  wire s_wvalid;
  output s_wready;
  wire s_wready;
  output [1:0] s_bresp;
  wire [1:0] s_bresp;
  output s_bvalid;
  wire s_bvalid;
  input s_bready;
  wire s_bready;
  input [11:0] s_araddr;
  wire [11:0] s_araddr;
  input s_arvalid;
  wire s_arvalid;
  output s_arready;
  wire s_arready;
  output [31:0] s_rdata;
  wire [31:0] s_rdata;
  output [1:0] s_rresp;
  wire [1:0] s_rresp;
  output s_rvalid;
  wire s_rvalid;
  input s_rready;
  wire s_rready;
  input uart_rx;
  wire uart_rx;
  output uart_tx;
  wire uart_tx;
  output irq;
  wire irq;
  wire _00_;
  wire _01_;
  wire _02_;
  wire _03_;
  wire _04_;
  wire _05_;
  wire _06_;
  wire _07_;
  wire _08_;
  wire _09_;
  wire _10_;
  wire _11_;
  wire [11:0] apb_paddr;
  wire apb_penable;
  wire [31:0] apb_prdata;
  wire apb_pready;
  wire apb_psel;
  wire apb_pslverr;
  wire [31:0] apb_pwdata;
  wire apb_pwrite;
  wire filtered_rx_r;
  wire [31:0] prdata_muxed;
  wire pwrite_gated;
  wire [2:0] rx_sr;
  wire sout_from_uart;
  INV_X1 _12_ (
    .A(apb_prdata[5]),
    .ZN(_01_)
  );
  INV_X1 _13_ (
    .A(rx_sr[1]),
    .ZN(_02_)
  );
  INV_X1 _14_ (
    .A(apb_pwrite),
    .ZN(_03_)
  );
  OR2_X1 _15_ (
    .A1(apb_paddr[3]),
    .A2(apb_paddr[4]),
    .ZN(_04_)
  );
  NAND2_X1 _16_ (
    .A1(apb_paddr[2]),
    .A2(secure_mode),
    .ZN(_05_)
  );
  OAI21_X1 _17_ (
    .A(_01_),
    .B1(_04_),
    .B2(_05_),
    .ZN(prdata_muxed[5])
  );
  OR2_X1 _18_ (
    .A1(secure_mode),
    .A2(sout_from_uart),
    .ZN(uart_tx)
  );
  NOR2_X1 _19_ (
    .A1(secure_mode),
    .A2(_03_),
    .ZN(pwrite_gated)
  );
  AOI21_X1 _20_ (
    .A(filtered_rx_r),
    .B1(rx_sr[2]),
    .B2(rx_sr[0]),
    .ZN(_06_)
  );
  OAI21_X1 _21_ (
    .A(filtered_rx_r),
    .B1(rx_sr[2]),
    .B2(rx_sr[0]),
    .ZN(_07_)
  );
  OAI21_X1 _22_ (
    .A(_07_),
    .B1(_06_),
    .B2(_02_),
    .ZN(_00_)
  );
  DFFS_X1 _23_ (
    .CK(clk),
    .D(_00_),
    .Q(filtered_rx_r),
    .QN(_10_),
    .SN(rst_n)
  );
  DFFS_X1 _24_ (
    .CK(clk),
    .D(uart_rx),
    .Q(rx_sr[0]),
    .QN(_08_),
    .SN(rst_n)
  );
  DFFS_X1 _25_ (
    .CK(clk),
    .D(rx_sr[0]),
    .Q(rx_sr[1]),
    .QN(_11_),
    .SN(rst_n)
  );
  DFFS_X1 _26_ (
    .CK(clk),
    .D(rx_sr[1]),
    .Q(rx_sr[2]),
    .QN(_09_),
    .SN(rst_n)
  );
  axil_to_apb u_bridge (
    .clk(clk),
    .paddr(apb_paddr),
    .penable(apb_penable),
    .prdata({ apb_prdata[31:6], prdata_muxed[5], apb_prdata[4:0] }),
    .pready(apb_pready),
    .psel(apb_psel),
    .pslverr(apb_pslverr),
    .pwdata(apb_pwdata),
    .pwrite(apb_pwrite),
    .rst_n(rst_n),
    .s_araddr(s_araddr),
    .s_arready(s_arready),
    .s_arvalid(s_arvalid),
    .s_awaddr(s_awaddr),
    .s_awready(s_awready),
    .s_awvalid(s_awvalid),
    .s_bready(s_bready),
    .s_bresp(s_bresp),
    .s_bvalid(s_bvalid),
    .s_rdata(s_rdata),
    .s_rready(s_rready),
    .s_rresp(s_rresp),
    .s_rvalid(s_rvalid),
    .s_wdata(s_wdata),
    .s_wready(s_wready),
    .s_wstrb(s_wstrb),
    .s_wvalid(s_wvalid)
  );
  apb_uart u_uart (
    .CLK(clk),
    .CTSN(1'h1),
    .DCDN(1'h1),
    .DSRN(1'h1),
    .INT(irq),
    .PADDR(apb_paddr[4:2]),
    .PENABLE(apb_penable),
    .PRDATA(apb_prdata),
    .PREADY(apb_pready),
    .PSEL(apb_psel),
    .PSLVERR(apb_pslverr),
    .PWDATA(apb_pwdata),
    .PWRITE(pwrite_gated),
    .RIN(1'h1),
    .RSTN(rst_n),
    .SIN(filtered_rx_r),
    .SOUT(sout_from_uart)
  );
  assign { prdata_muxed[31:6], prdata_muxed[4:0] } = { apb_prdata[31:6], apb_prdata[4:0] };
endmodule
