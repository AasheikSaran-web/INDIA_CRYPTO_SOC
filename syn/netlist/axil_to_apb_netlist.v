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
