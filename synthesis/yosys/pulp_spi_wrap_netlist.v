module \$paramod$83bc75265b358b15e6cbe03cbfc629e968b46589\apb_spi_master (HCLK, HRESETn, PADDR, PWDATA, PWRITE, PSEL, PENABLE, PRDATA, PREADY, PSLVERR, events_o, spi_clk, spi_csn0, spi_csn1, spi_csn2, spi_csn3, spi_mode, spi_sdo0, spi_sdo1, spi_sdo2, spi_sdo3
, spi_sdi0, spi_sdi1, spi_sdi2, spi_sdi3);
  input HCLK;
  wire HCLK;
  input HRESETn;
  wire HRESETn;
  input [11:0] PADDR;
  wire [11:0] PADDR;
  input [31:0] PWDATA;
  wire [31:0] PWDATA;
  input PWRITE;
  wire PWRITE;
  input PSEL;
  wire PSEL;
  input PENABLE;
  wire PENABLE;
  output [31:0] PRDATA;
  wire [31:0] PRDATA;
  output PREADY;
  wire PREADY;
  output PSLVERR;
  wire PSLVERR;
  output [1:0] events_o;
  wire [1:0] events_o;
  output spi_clk;
  wire spi_clk;
  output spi_csn0;
  wire spi_csn0;
  output spi_csn1;
  wire spi_csn1;
  output spi_csn2;
  wire spi_csn2;
  output spi_csn3;
  wire spi_csn3;
  output [1:0] spi_mode;
  wire [1:0] spi_mode;
  output spi_sdo0;
  wire spi_sdo0;
  output spi_sdo1;
  wire spi_sdo1;
  output spi_sdo2;
  wire spi_sdo2;
  output spi_sdo3;
  wire spi_sdo3;
  input spi_sdi0;
  wire spi_sdi0;
  input spi_sdi1;
  wire spi_sdi1;
  input spi_sdi2;
  wire spi_sdi2;
  input spi_sdi3;
  wire spi_sdi3;
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
  wire [4:0] elements_rx;
  wire [4:0] elements_tx;
  wire [4:0] r_counter_rx;
  wire [4:0] r_counter_tx;
  wire [2:0] r_state_rx;
  wire [2:0] r_state_tx;
  wire [4:0] s_cnt_rx;
  wire [4:0] s_cnt_tx;
  wire s_eot;
  wire s_int_cnt_en;
  wire s_int_en;
  wire s_int_rd_intsta;
  wire s_int_rx;
  wire s_int_tx;
  wire [4:0] s_th_rx;
  wire [4:0] s_th_tx;
  wire [31:0] spi_addr;
  wire [5:0] spi_addr_len;
  wire [7:0] spi_clk_div;
  wire spi_clk_div_valid;
  wire [31:0] spi_cmd;
  wire [5:0] spi_cmd_len;
  wire [3:0] spi_csreg;
  wire [31:0] spi_ctrl_data_rx;
  wire spi_ctrl_data_rx_ready;
  wire spi_ctrl_data_rx_valid;
  wire [31:0] spi_ctrl_data_tx;
  wire spi_ctrl_data_tx_ready;
  wire spi_ctrl_data_tx_valid;
  wire [6:0] spi_ctrl_status;
  wire [15:0] spi_data_len;
  wire [31:0] spi_data_rx;
  wire spi_data_rx_ready;
  wire spi_data_rx_valid;
  wire [31:0] spi_data_tx;
  wire spi_data_tx_ready;
  wire spi_data_tx_valid;
  wire [15:0] spi_dummy_rd;
  wire [15:0] spi_dummy_wr;
  wire spi_qrd;
  wire spi_qwr;
  wire spi_rd;
  wire [28:0] spi_status;
  wire spi_swrst;
  wire spi_wr;
  INV_X1 _133_ (
    .A(s_cnt_tx[0]),
    .ZN(_088_)
  );
  INV_X1 _134_ (
    .A(s_cnt_tx[3]),
    .ZN(_089_)
  );
  INV_X1 _135_ (
    .A(s_cnt_tx[4]),
    .ZN(_090_)
  );
  INV_X1 _136_ (
    .A(r_counter_tx[4]),
    .ZN(_091_)
  );
  INV_X1 _137_ (
    .A(s_int_cnt_en),
    .ZN(_092_)
  );
  INV_X1 _138_ (
    .A(s_cnt_rx[0]),
    .ZN(_093_)
  );
  INV_X1 _139_ (
    .A(s_cnt_rx[3]),
    .ZN(_094_)
  );
  INV_X1 _140_ (
    .A(r_counter_rx[3]),
    .ZN(_095_)
  );
  INV_X1 _141_ (
    .A(s_cnt_rx[4]),
    .ZN(_096_)
  );
  INV_X1 _142_ (
    .A(r_counter_rx[0]),
    .ZN(_097_)
  );
  INV_X1 _143_ (
    .A(elements_tx[3]),
    .ZN(_098_)
  );
  INV_X1 _144_ (
    .A(s_th_tx[2]),
    .ZN(_099_)
  );
  INV_X1 _145_ (
    .A(s_th_tx[1]),
    .ZN(_100_)
  );
  INV_X1 _146_ (
    .A(s_th_tx[0]),
    .ZN(_101_)
  );
  INV_X1 _147_ (
    .A(elements_tx[4]),
    .ZN(_102_)
  );
  INV_X1 _148_ (
    .A(r_state_tx[0]),
    .ZN(_103_)
  );
  INV_X1 _149_ (
    .A(r_state_tx[1]),
    .ZN(_104_)
  );
  INV_X1 _150_ (
    .A(r_state_rx[1]),
    .ZN(_105_)
  );
  INV_X1 _151_ (
    .A(elements_rx[1]),
    .ZN(_106_)
  );
  INV_X1 _152_ (
    .A(elements_rx[0]),
    .ZN(_107_)
  );
  INV_X1 _153_ (
    .A(elements_rx[2]),
    .ZN(_108_)
  );
  INV_X1 _154_ (
    .A(s_th_rx[3]),
    .ZN(_109_)
  );
  INV_X1 _155_ (
    .A(s_th_rx[4]),
    .ZN(_110_)
  );
  INV_X1 _156_ (
    .A(r_state_rx[0]),
    .ZN(_111_)
  );
  AOI22_X1 _157_ (
    .A1(_100_),
    .A2(elements_tx[1]),
    .B1(_101_),
    .B2(elements_tx[0]),
    .ZN(_112_)
  );
  NAND2_X1 _158_ (
    .A1(elements_tx[2]),
    .A2(_099_),
    .ZN(_113_)
  );
  OAI22_X1 _159_ (
    .A1(elements_tx[2]),
    .A2(_099_),
    .B1(_100_),
    .B2(elements_tx[1]),
    .ZN(_114_)
  );
  OAI221_X1 _160_ (
    .A(_113_),
    .B1(_114_),
    .B2(_112_),
    .C1(_098_),
    .C2(s_th_tx[3]),
    .ZN(_115_)
  );
  AOI22_X1 _161_ (
    .A1(s_th_tx[3]),
    .A2(_098_),
    .B1(_102_),
    .B2(s_th_tx[4]),
    .ZN(_116_)
  );
  OAI21_X1 _162_ (
    .A(s_int_en),
    .B1(s_th_tx[4]),
    .B2(_102_),
    .ZN(_016_)
  );
  AOI21_X1 _163_ (
    .A(_016_),
    .B1(_116_),
    .B2(_115_),
    .ZN(_017_)
  );
  AND2_X1 _164_ (
    .A1(_092_),
    .A2(s_int_rd_intsta),
    .ZN(_018_)
  );
  NOR2_X1 _165_ (
    .A1(s_cnt_tx[1]),
    .A2(s_cnt_tx[0]),
    .ZN(_019_)
  );
  NOR3_X1 _166_ (
    .A1(s_cnt_tx[1]),
    .A2(s_cnt_tx[0]),
    .A3(s_cnt_tx[2]),
    .ZN(_020_)
  );
  XNOR2_X1 _167_ (
    .A(s_cnt_tx[2]),
    .B(_019_),
    .ZN(_021_)
  );
  XNOR2_X1 _168_ (
    .A(r_counter_tx[2]),
    .B(_021_),
    .ZN(_022_)
  );
  XNOR2_X1 _169_ (
    .A(s_cnt_tx[1]),
    .B(r_counter_tx[1]),
    .ZN(_023_)
  );
  AND2_X1 _170_ (
    .A1(_088_),
    .A2(r_counter_tx[0]),
    .ZN(_024_)
  );
  OAI21_X1 _171_ (
    .A(_023_),
    .B1(r_counter_tx[0]),
    .B2(_088_),
    .ZN(_025_)
  );
  OAI221_X1 _172_ (
    .A(_025_),
    .B1(_024_),
    .B2(_023_),
    .C1(s_cnt_tx[4]),
    .C2(_091_),
    .ZN(_026_)
  );
  OAI22_X1 _173_ (
    .A1(_089_),
    .A2(r_counter_tx[3]),
    .B1(_090_),
    .B2(r_counter_tx[4]),
    .ZN(_027_)
  );
  NAND2_X1 _174_ (
    .A1(_089_),
    .A2(r_counter_tx[3]),
    .ZN(_028_)
  );
  OAI21_X1 _175_ (
    .A(_020_),
    .B1(r_counter_tx[4]),
    .B2(_090_),
    .ZN(_029_)
  );
  AND3_X1 _176_ (
    .A1(_027_),
    .A2(_028_),
    .A3(_029_),
    .ZN(_030_)
  );
  AOI22_X1 _177_ (
    .A1(_020_),
    .A2(_027_),
    .B1(_028_),
    .B2(_029_),
    .ZN(_031_)
  );
  NOR4_X1 _178_ (
    .A1(_022_),
    .A2(_026_),
    .A3(_030_),
    .A4(_031_),
    .ZN(_032_)
  );
  OR4_X1 _179_ (
    .A1(_022_),
    .A2(_026_),
    .A3(_030_),
    .A4(_031_),
    .ZN(_033_)
  );
  NAND2_X1 _180_ (
    .A1(spi_ctrl_data_tx_valid),
    .A2(spi_ctrl_data_tx_ready),
    .ZN(_034_)
  );
  NOR2_X1 _181_ (
    .A1(_092_),
    .A2(_034_),
    .ZN(_035_)
  );
  AOI21_X1 _182_ (
    .A(_018_),
    .B1(_032_),
    .B2(_035_),
    .ZN(_036_)
  );
  OAI22_X1 _183_ (
    .A1(_103_),
    .A2(_017_),
    .B1(_036_),
    .B2(_104_),
    .ZN(_004_)
  );
  AOI211_X1 _184_ (
    .A(_104_),
    .B(_018_),
    .C1(_032_),
    .C2(_035_),
    .ZN(_037_)
  );
  OR2_X1 _185_ (
    .A1(r_state_tx[2]),
    .A2(_037_),
    .ZN(_005_)
  );
  NOR2_X1 _186_ (
    .A1(s_cnt_rx[1]),
    .A2(s_cnt_rx[0]),
    .ZN(_038_)
  );
  NOR3_X1 _187_ (
    .A1(s_cnt_rx[1]),
    .A2(s_cnt_rx[0]),
    .A3(s_cnt_rx[2]),
    .ZN(_039_)
  );
  XNOR2_X1 _188_ (
    .A(s_cnt_rx[2]),
    .B(_038_),
    .ZN(_040_)
  );
  XNOR2_X1 _189_ (
    .A(r_counter_rx[2]),
    .B(_040_),
    .ZN(_041_)
  );
  XNOR2_X1 _190_ (
    .A(s_cnt_rx[1]),
    .B(r_counter_rx[1]),
    .ZN(_042_)
  );
  OAI21_X1 _191_ (
    .A(_042_),
    .B1(r_counter_rx[0]),
    .B2(_093_),
    .ZN(_043_)
  );
  NAND2_X1 _192_ (
    .A1(_096_),
    .A2(r_counter_rx[4]),
    .ZN(_044_)
  );
  NOR2_X1 _193_ (
    .A1(s_cnt_rx[0]),
    .A2(_097_),
    .ZN(_045_)
  );
  OAI211_X1 _194_ (
    .A(_043_),
    .B(_044_),
    .C1(_045_),
    .C2(_042_),
    .ZN(_046_)
  );
  OAI22_X1 _195_ (
    .A1(_094_),
    .A2(r_counter_rx[3]),
    .B1(_096_),
    .B2(r_counter_rx[4]),
    .ZN(_047_)
  );
  NAND2_X1 _196_ (
    .A1(_094_),
    .A2(r_counter_rx[3]),
    .ZN(_048_)
  );
  OAI21_X1 _197_ (
    .A(_039_),
    .B1(r_counter_rx[4]),
    .B2(_096_),
    .ZN(_049_)
  );
  AND3_X1 _198_ (
    .A1(_047_),
    .A2(_048_),
    .A3(_049_),
    .ZN(_050_)
  );
  AOI22_X1 _199_ (
    .A1(_039_),
    .A2(_047_),
    .B1(_048_),
    .B2(_049_),
    .ZN(_051_)
  );
  NOR4_X1 _200_ (
    .A1(_041_),
    .A2(_046_),
    .A3(_050_),
    .A4(_051_),
    .ZN(_052_)
  );
  OR4_X1 _201_ (
    .A1(_041_),
    .A2(_046_),
    .A3(_050_),
    .A4(_051_),
    .ZN(_053_)
  );
  AND3_X1 _202_ (
    .A1(s_int_cnt_en),
    .A2(spi_ctrl_data_rx_valid),
    .A3(spi_ctrl_data_rx_ready),
    .ZN(_054_)
  );
  AOI21_X1 _203_ (
    .A(_018_),
    .B1(_052_),
    .B2(_054_),
    .ZN(_055_)
  );
  AOI211_X1 _204_ (
    .A(_105_),
    .B(_018_),
    .C1(_052_),
    .C2(_054_),
    .ZN(_056_)
  );
  OR2_X1 _205_ (
    .A1(r_state_rx[2]),
    .A2(_056_),
    .ZN(_003_)
  );
  AOI22_X1 _206_ (
    .A1(_106_),
    .A2(s_th_rx[1]),
    .B1(_107_),
    .B2(s_th_rx[0]),
    .ZN(_057_)
  );
  OAI22_X1 _207_ (
    .A1(_106_),
    .A2(s_th_rx[1]),
    .B1(s_th_rx[2]),
    .B2(_108_),
    .ZN(_058_)
  );
  NAND2_X1 _208_ (
    .A1(s_th_rx[2]),
    .A2(_108_),
    .ZN(_059_)
  );
  OAI221_X1 _209_ (
    .A(_059_),
    .B1(_058_),
    .B2(_057_),
    .C1(elements_rx[3]),
    .C2(_109_),
    .ZN(_060_)
  );
  AOI22_X1 _210_ (
    .A1(elements_rx[3]),
    .A2(_109_),
    .B1(_110_),
    .B2(elements_rx[4]),
    .ZN(_061_)
  );
  OAI21_X1 _211_ (
    .A(s_int_en),
    .B1(_110_),
    .B2(elements_rx[4]),
    .ZN(_062_)
  );
  AOI21_X1 _212_ (
    .A(_062_),
    .B1(_061_),
    .B2(_060_),
    .ZN(_063_)
  );
  OAI22_X1 _213_ (
    .A1(_105_),
    .A2(_055_),
    .B1(_063_),
    .B2(_111_),
    .ZN(_002_)
  );
  AND2_X1 _214_ (
    .A1(r_state_rx[0]),
    .A2(_063_),
    .ZN(_000_)
  );
  AND2_X1 _215_ (
    .A1(r_state_tx[0]),
    .A2(_017_),
    .ZN(_001_)
  );
  OR2_X1 _216_ (
    .A1(r_state_tx[2]),
    .A2(r_state_rx[2]),
    .ZN(events_o[0])
  );
  NAND2_X1 _217_ (
    .A1(s_int_cnt_en),
    .A2(_034_),
    .ZN(_064_)
  );
  NAND2_X1 _218_ (
    .A1(r_counter_tx[1]),
    .A2(r_counter_tx[0]),
    .ZN(_065_)
  );
  AOI21_X1 _219_ (
    .A(_065_),
    .B1(_034_),
    .B2(s_int_cnt_en),
    .ZN(_066_)
  );
  AND2_X1 _220_ (
    .A1(r_counter_tx[2]),
    .A2(_066_),
    .ZN(_067_)
  );
  NOR2_X1 _221_ (
    .A1(r_counter_tx[3]),
    .A2(_067_),
    .ZN(_068_)
  );
  OAI21_X1 _222_ (
    .A(s_int_cnt_en),
    .B1(_033_),
    .B2(_034_),
    .ZN(_069_)
  );
  NAND2_X1 _223_ (
    .A1(r_counter_tx[3]),
    .A2(_067_),
    .ZN(_070_)
  );
  OAI211_X1 _224_ (
    .A(s_int_cnt_en),
    .B(_070_),
    .C1(_034_),
    .C2(_033_),
    .ZN(_071_)
  );
  NOR2_X1 _225_ (
    .A1(_068_),
    .A2(_071_),
    .ZN(_006_)
  );
  NOR2_X1 _226_ (
    .A1(r_counter_tx[2]),
    .A2(_066_),
    .ZN(_072_)
  );
  NOR3_X1 _227_ (
    .A1(_067_),
    .A2(_069_),
    .A3(_072_),
    .ZN(_007_)
  );
  AOI21_X1 _228_ (
    .A(r_counter_tx[1]),
    .B1(r_counter_tx[0]),
    .B2(_064_),
    .ZN(_073_)
  );
  NOR3_X1 _229_ (
    .A1(_066_),
    .A2(_069_),
    .A3(_073_),
    .ZN(_008_)
  );
  AOI21_X1 _230_ (
    .A(r_counter_tx[0]),
    .B1(_033_),
    .B2(_035_),
    .ZN(_074_)
  );
  AOI21_X1 _231_ (
    .A(_074_),
    .B1(_064_),
    .B2(r_counter_tx[0]),
    .ZN(_009_)
  );
  NAND3_X1 _232_ (
    .A1(r_counter_rx[1]),
    .A2(r_counter_rx[2]),
    .A3(r_counter_rx[0]),
    .ZN(_075_)
  );
  AOI21_X1 _233_ (
    .A(_092_),
    .B1(spi_ctrl_data_rx_valid),
    .B2(spi_ctrl_data_rx_ready),
    .ZN(_076_)
  );
  NAND2_X1 _234_ (
    .A1(r_counter_rx[3]),
    .A2(_076_),
    .ZN(_077_)
  );
  NAND2_X1 _235_ (
    .A1(_053_),
    .A2(_054_),
    .ZN(_078_)
  );
  XNOR2_X1 _236_ (
    .A(_095_),
    .B(_075_),
    .ZN(_079_)
  );
  OAI21_X1 _237_ (
    .A(_077_),
    .B1(_078_),
    .B2(_079_),
    .ZN(_010_)
  );
  NAND3_X1 _238_ (
    .A1(_091_),
    .A2(s_int_cnt_en),
    .A3(_033_),
    .ZN(_080_)
  );
  AOI22_X1 _239_ (
    .A1(_091_),
    .A2(_070_),
    .B1(_071_),
    .B2(_080_),
    .ZN(_011_)
  );
  AOI21_X1 _240_ (
    .A(_076_),
    .B1(_053_),
    .B2(s_int_cnt_en),
    .ZN(_081_)
  );
  NOR3_X1 _241_ (
    .A1(_095_),
    .A2(_075_),
    .A3(_076_),
    .ZN(_082_)
  );
  XNOR2_X1 _242_ (
    .A(r_counter_rx[4]),
    .B(_082_),
    .ZN(_083_)
  );
  NOR2_X1 _243_ (
    .A1(_081_),
    .A2(_083_),
    .ZN(_012_)
  );
  NOR2_X1 _244_ (
    .A1(_097_),
    .A2(_076_),
    .ZN(_084_)
  );
  AND2_X1 _245_ (
    .A1(r_counter_rx[1]),
    .A2(_084_),
    .ZN(_085_)
  );
  XNOR2_X1 _246_ (
    .A(r_counter_rx[2]),
    .B(_085_),
    .ZN(_086_)
  );
  NOR2_X1 _247_ (
    .A1(_081_),
    .A2(_086_),
    .ZN(_013_)
  );
  NOR2_X1 _248_ (
    .A1(r_counter_rx[1]),
    .A2(_084_),
    .ZN(_087_)
  );
  NOR3_X1 _249_ (
    .A1(_081_),
    .A2(_085_),
    .A3(_087_),
    .ZN(_014_)
  );
  AOI21_X1 _250_ (
    .A(_084_),
    .B1(_078_),
    .B2(_097_),
    .ZN(_015_)
  );
  DFFR_X1 _251_ (
    .CK(HCLK),
    .D(_009_),
    .Q(r_counter_tx[0]),
    .QN(_131_),
    .RN(HRESETn)
  );
  DFFR_X1 _252_ (
    .CK(HCLK),
    .D(_008_),
    .Q(r_counter_tx[1]),
    .QN(_129_),
    .RN(HRESETn)
  );
  DFFR_X1 _253_ (
    .CK(HCLK),
    .D(_007_),
    .Q(r_counter_tx[2]),
    .QN(_125_),
    .RN(HRESETn)
  );
  DFFR_X1 _254_ (
    .CK(HCLK),
    .D(_006_),
    .Q(r_counter_tx[3]),
    .QN(_126_),
    .RN(HRESETn)
  );
  DFFR_X1 _255_ (
    .CK(HCLK),
    .D(_011_),
    .Q(r_counter_tx[4]),
    .QN(_121_),
    .RN(HRESETn)
  );
  DFFR_X1 _256_ (
    .CK(HCLK),
    .D(_015_),
    .Q(r_counter_rx[0]),
    .QN(_117_),
    .RN(HRESETn)
  );
  DFFR_X1 _257_ (
    .CK(HCLK),
    .D(_014_),
    .Q(r_counter_rx[1]),
    .QN(_118_),
    .RN(HRESETn)
  );
  DFFR_X1 _258_ (
    .CK(HCLK),
    .D(_013_),
    .Q(r_counter_rx[2]),
    .QN(_119_),
    .RN(HRESETn)
  );
  DFFR_X1 _259_ (
    .CK(HCLK),
    .D(_010_),
    .Q(r_counter_rx[3]),
    .QN(_122_),
    .RN(HRESETn)
  );
  DFFR_X1 _260_ (
    .CK(HCLK),
    .D(_012_),
    .Q(r_counter_rx[4]),
    .QN(_120_),
    .RN(HRESETn)
  );
  DFFS_X1 _261_ (
    .CK(HCLK),
    .D(_004_),
    .Q(r_state_tx[0]),
    .QN(_123_),
    .SN(HRESETn)
  );
  DFFR_X1 _262_ (
    .CK(HCLK),
    .D(_005_),
    .Q(r_state_tx[1]),
    .QN(_132_),
    .RN(HRESETn)
  );
  DFFR_X1 _263_ (
    .CK(HCLK),
    .D(_001_),
    .Q(r_state_tx[2]),
    .QN(_130_),
    .RN(HRESETn)
  );
  DFFS_X1 _264_ (
    .CK(HCLK),
    .D(_002_),
    .Q(r_state_rx[0]),
    .QN(_127_),
    .SN(HRESETn)
  );
  DFFR_X1 _265_ (
    .CK(HCLK),
    .D(_003_),
    .Q(r_state_rx[1]),
    .QN(_128_),
    .RN(HRESETn)
  );
  DFFR_X1 _266_ (
    .CK(HCLK),
    .D(_000_),
    .Q(r_state_rx[2]),
    .QN(_124_),
    .RN(HRESETn)
  );
  \$paramod$83bc75265b358b15e6cbe03cbfc629e968b46589\spi_master_apb_if  u_axiregs (
    .HCLK(HCLK),
    .HRESETn(HRESETn),
    .PADDR(PADDR),
    .PENABLE(PENABLE),
    .PRDATA(PRDATA),
    .PREADY(PREADY),
    .PSEL(PSEL),
    .PSLVERR(PSLVERR),
    .PWDATA(PWDATA),
    .PWRITE(PWRITE),
    .spi_addr(spi_addr),
    .spi_addr_len(spi_addr_len),
    .spi_clk_div(spi_clk_div),
    .spi_clk_div_valid(spi_clk_div_valid),
    .spi_cmd(spi_cmd),
    .spi_cmd_len(spi_cmd_len),
    .spi_csreg(spi_csreg),
    .spi_data_len(spi_data_len),
    .spi_data_rx(spi_data_rx),
    .spi_data_rx_ready(spi_data_rx_ready),
    .spi_data_rx_valid(spi_data_rx_valid),
    .spi_data_tx(spi_data_tx),
    .spi_data_tx_ready(spi_data_tx_ready),
    .spi_data_tx_valid(spi_data_tx_valid),
    .spi_dummy_rd(spi_dummy_rd),
    .spi_dummy_wr(spi_dummy_wr),
    .spi_int_cnt_en(s_int_cnt_en),
    .spi_int_cnt_rx(s_cnt_rx),
    .spi_int_cnt_tx(s_cnt_tx),
    .spi_int_en(s_int_en),
    .spi_int_rd_sta(s_int_rd_intsta),
    .spi_int_th_rx(s_th_rx),
    .spi_int_th_tx(s_th_tx),
    .spi_qrd(spi_qrd),
    .spi_qwr(spi_qwr),
    .spi_rd(spi_rd),
    .spi_status({ 3'h0, elements_tx, 3'h0, elements_rx, 9'h000, spi_ctrl_status }),
    .spi_swrst(spi_swrst),
    .spi_wr(spi_wr)
  );
  \$paramod$dec9424b776ed6cf19510f938baf4f9a5bd62edc\spi_master_fifo  u_rxfifo (
    .clk_i(HCLK),
    .clr_i(spi_swrst),
    .data_i(spi_ctrl_data_rx),
    .data_o(spi_data_rx),
    .elements_o(elements_rx),
    .ready_i(spi_data_rx_ready),
    .ready_o(spi_ctrl_data_rx_ready),
    .rst_ni(HRESETn),
    .valid_i(spi_ctrl_data_rx_valid),
    .valid_o(spi_data_rx_valid)
  );
  spi_master_controller u_spictrl (
    .clk(HCLK),
    .eot(s_eot),
    .rstn(HRESETn),
    .spi_addr(spi_addr),
    .spi_addr_len(spi_addr_len),
    .spi_clk(spi_clk),
    .spi_clk_div(spi_clk_div),
    .spi_clk_div_valid(spi_clk_div_valid),
    .spi_cmd(spi_cmd),
    .spi_cmd_len(spi_cmd_len),
    .spi_csn0(spi_csn0),
    .spi_csn1(spi_csn1),
    .spi_csn2(spi_csn2),
    .spi_csn3(spi_csn3),
    .spi_csreg(spi_csreg),
    .spi_ctrl_data_rx(spi_ctrl_data_rx),
    .spi_ctrl_data_rx_ready(spi_ctrl_data_rx_ready),
    .spi_ctrl_data_rx_valid(spi_ctrl_data_rx_valid),
    .spi_ctrl_data_tx(spi_ctrl_data_tx),
    .spi_ctrl_data_tx_ready(spi_ctrl_data_tx_ready),
    .spi_ctrl_data_tx_valid(spi_ctrl_data_tx_valid),
    .spi_data_len(spi_data_len),
    .spi_dummy_rd(spi_dummy_rd),
    .spi_dummy_wr(spi_dummy_wr),
    .spi_mode(spi_mode),
    .spi_qrd(spi_qrd),
    .spi_qwr(spi_qwr),
    .spi_rd(spi_rd),
    .spi_sdi0(spi_sdi0),
    .spi_sdi1(spi_sdi1),
    .spi_sdi2(spi_sdi2),
    .spi_sdi3(spi_sdi3),
    .spi_sdo0(spi_sdo0),
    .spi_sdo1(spi_sdo1),
    .spi_sdo2(spi_sdo2),
    .spi_sdo3(spi_sdo3),
    .spi_status(spi_ctrl_status),
    .spi_swrst(spi_swrst),
    .spi_wr(spi_wr)
  );
  \$paramod$dec9424b776ed6cf19510f938baf4f9a5bd62edc\spi_master_fifo  u_txfifo (
    .clk_i(HCLK),
    .clr_i(spi_swrst),
    .data_i(spi_data_tx),
    .data_o(spi_ctrl_data_tx),
    .elements_o(elements_tx),
    .ready_i(spi_ctrl_data_tx_ready),
    .ready_o(spi_data_tx_ready),
    .rst_ni(HRESETn),
    .valid_i(spi_data_tx_valid),
    .valid_o(spi_ctrl_data_tx_valid)
  );
  assign spi_status = { elements_tx, 3'h0, elements_rx, 9'h000, spi_ctrl_status };
  assign s_int_rx = r_state_rx[2];
  assign s_int_tx = r_state_tx[2];
  assign events_o[1] = s_eot;
endmodule

module \$paramod$83bc75265b358b15e6cbe03cbfc629e968b46589\spi_master_apb_if (HCLK, HRESETn, PADDR, PWDATA, PWRITE, PSEL, PENABLE, PRDATA, PREADY, PSLVERR, spi_clk_div, spi_clk_div_valid, spi_status, spi_addr, spi_addr_len, spi_cmd, spi_cmd_len, spi_csreg, spi_data_len, spi_dummy_rd, spi_dummy_wr
, spi_int_th_tx, spi_int_th_rx, spi_int_cnt_tx, spi_int_cnt_rx, spi_int_en, spi_int_cnt_en, spi_int_rd_sta, spi_swrst, spi_rd, spi_wr, spi_qrd, spi_qwr, spi_data_tx, spi_data_tx_valid, spi_data_tx_ready, spi_data_rx, spi_data_rx_valid, spi_data_rx_ready);
  input HCLK;
  wire HCLK;
  input HRESETn;
  wire HRESETn;
  input [11:0] PADDR;
  wire [11:0] PADDR;
  input [31:0] PWDATA;
  wire [31:0] PWDATA;
  input PWRITE;
  wire PWRITE;
  input PSEL;
  wire PSEL;
  input PENABLE;
  wire PENABLE;
  output [31:0] PRDATA;
  wire [31:0] PRDATA;
  output PREADY;
  wire PREADY;
  output PSLVERR;
  wire PSLVERR;
  output [7:0] spi_clk_div;
  wire [7:0] spi_clk_div;
  output spi_clk_div_valid;
  wire spi_clk_div_valid;
  input [31:0] spi_status;
  wire [31:0] spi_status;
  output [31:0] spi_addr;
  wire [31:0] spi_addr;
  output [5:0] spi_addr_len;
  wire [5:0] spi_addr_len;
  output [31:0] spi_cmd;
  wire [31:0] spi_cmd;
  output [5:0] spi_cmd_len;
  wire [5:0] spi_cmd_len;
  output [3:0] spi_csreg;
  wire [3:0] spi_csreg;
  output [15:0] spi_data_len;
  wire [15:0] spi_data_len;
  output [15:0] spi_dummy_rd;
  wire [15:0] spi_dummy_rd;
  output [15:0] spi_dummy_wr;
  wire [15:0] spi_dummy_wr;
  output [4:0] spi_int_th_tx;
  wire [4:0] spi_int_th_tx;
  output [4:0] spi_int_th_rx;
  wire [4:0] spi_int_th_rx;
  output [4:0] spi_int_cnt_tx;
  wire [4:0] spi_int_cnt_tx;
  output [4:0] spi_int_cnt_rx;
  wire [4:0] spi_int_cnt_rx;
  output spi_int_en;
  wire spi_int_en;
  output spi_int_cnt_en;
  wire spi_int_cnt_en;
  output spi_int_rd_sta;
  wire spi_int_rd_sta;
  output spi_swrst;
  wire spi_swrst;
  output spi_rd;
  wire spi_rd;
  output spi_wr;
  wire spi_wr;
  output spi_qrd;
  wire spi_qrd;
  output spi_qwr;
  wire spi_qwr;
  output [31:0] spi_data_tx;
  wire [31:0] spi_data_tx;
  output spi_data_tx_valid;
  wire spi_data_tx_valid;
  input spi_data_tx_ready;
  wire spi_data_tx_ready;
  input [31:0] spi_data_rx;
  wire [31:0] spi_data_rx;
  input spi_data_rx_valid;
  wire spi_data_rx_valid;
  output spi_data_rx_ready;
  wire spi_data_rx_ready;
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
  wire _201_;
  wire _202_;
  wire _203_;
  wire _204_;
  wire _205_;
  wire _206_;
  wire _207_;
  wire _208_;
  wire _209_;
  wire _210_;
  wire _211_;
  wire _212_;
  wire _213_;
  wire _214_;
  wire _215_;
  wire _216_;
  wire _217_;
  wire _218_;
  wire _219_;
  wire _220_;
  wire _221_;
  wire _222_;
  wire _223_;
  wire _224_;
  wire _225_;
  wire _226_;
  wire _227_;
  wire _228_;
  wire _229_;
  wire _230_;
  wire _231_;
  wire _232_;
  wire _233_;
  wire _234_;
  wire _235_;
  wire _236_;
  wire _237_;
  wire _238_;
  wire _239_;
  wire _240_;
  wire _241_;
  wire _242_;
  wire _243_;
  wire _244_;
  wire _245_;
  wire _246_;
  wire _247_;
  wire _248_;
  wire _249_;
  wire _250_;
  wire _251_;
  wire _252_;
  wire _253_;
  wire _254_;
  wire _255_;
  wire _256_;
  wire _257_;
  wire _258_;
  wire _259_;
  wire _260_;
  wire _261_;
  wire _262_;
  wire _263_;
  wire _264_;
  wire _265_;
  wire _266_;
  wire _267_;
  wire _268_;
  wire _269_;
  wire _270_;
  wire _271_;
  wire _272_;
  wire _273_;
  wire _274_;
  wire _275_;
  wire _276_;
  wire _277_;
  wire _278_;
  wire _279_;
  wire _280_;
  wire _281_;
  wire _282_;
  wire _283_;
  wire _284_;
  wire _285_;
  wire _286_;
  wire _287_;
  wire _288_;
  wire _289_;
  wire _290_;
  wire _291_;
  wire _292_;
  wire _293_;
  wire _294_;
  wire _295_;
  wire _296_;
  wire _297_;
  wire _298_;
  wire _299_;
  wire _300_;
  wire _301_;
  wire _302_;
  wire _303_;
  wire _304_;
  wire _305_;
  wire _306_;
  wire _307_;
  wire _308_;
  wire _309_;
  wire _310_;
  wire _311_;
  wire _312_;
  wire _313_;
  wire _314_;
  wire _315_;
  wire _316_;
  wire _317_;
  wire _318_;
  wire _319_;
  wire _320_;
  wire _321_;
  wire _322_;
  wire _323_;
  wire _324_;
  wire _325_;
  wire _326_;
  wire _327_;
  wire _328_;
  wire _329_;
  wire _330_;
  wire _331_;
  wire _332_;
  wire _333_;
  wire _334_;
  wire _335_;
  wire _336_;
  wire _337_;
  wire _338_;
  wire _339_;
  wire _340_;
  wire _341_;
  wire _342_;
  wire _343_;
  wire _344_;
  wire _345_;
  wire _346_;
  wire _347_;
  wire _348_;
  wire _349_;
  wire _350_;
  wire _351_;
  wire _352_;
  wire _353_;
  wire _354_;
  wire _355_;
  wire _356_;
  wire _357_;
  wire _358_;
  wire _359_;
  wire _360_;
  wire _361_;
  wire _362_;
  wire _363_;
  wire _364_;
  wire _365_;
  wire _366_;
  wire _367_;
  wire _368_;
  wire _369_;
  wire _370_;
  wire _371_;
  wire _372_;
  wire _373_;
  wire _374_;
  wire _375_;
  wire _376_;
  wire _377_;
  wire _378_;
  wire _379_;
  wire _380_;
  wire _381_;
  wire _382_;
  wire _383_;
  wire _384_;
  wire _385_;
  wire _386_;
  wire _387_;
  wire _388_;
  wire _389_;
  wire _390_;
  wire _391_;
  wire _392_;
  wire _393_;
  wire _394_;
  wire _395_;
  wire _396_;
  wire _397_;
  wire _398_;
  wire _399_;
  wire _400_;
  wire _401_;
  wire _402_;
  wire _403_;
  wire _404_;
  wire _405_;
  wire _406_;
  wire _407_;
  wire _408_;
  wire _409_;
  wire _410_;
  wire _411_;
  wire _412_;
  wire _413_;
  wire _414_;
  wire _415_;
  wire _416_;
  wire _417_;
  wire _418_;
  wire _419_;
  wire _420_;
  wire _421_;
  wire _422_;
  wire _423_;
  wire _424_;
  wire _425_;
  wire _426_;
  wire _427_;
  wire _428_;
  wire _429_;
  wire _430_;
  wire _431_;
  wire _432_;
  wire _433_;
  wire _434_;
  wire _435_;
  wire _436_;
  wire _437_;
  wire _438_;
  wire _439_;
  wire _440_;
  wire _441_;
  wire _442_;
  wire _443_;
  wire _444_;
  wire _445_;
  wire _446_;
  wire _447_;
  wire _448_;
  wire _449_;
  wire [3:0] read_address;
  wire [3:0] write_address;
  INV_X1 _450_ (
    .A(PADDR[4]),
    .ZN(_164_)
  );
  INV_X1 _451_ (
    .A(PADDR[5]),
    .ZN(_165_)
  );
  INV_X1 _452_ (
    .A(PADDR[2]),
    .ZN(_166_)
  );
  INV_X1 _453_ (
    .A(PWRITE),
    .ZN(_167_)
  );
  NOR4_X1 _454_ (
    .A1(_164_),
    .A2(PADDR[5]),
    .A3(PADDR[3]),
    .A4(_166_),
    .ZN(_168_)
  );
  NOR2_X1 _455_ (
    .A1(PADDR[4]),
    .A2(PADDR[5]),
    .ZN(_169_)
  );
  NOR4_X1 _456_ (
    .A1(PADDR[4]),
    .A2(PADDR[5]),
    .A3(PADDR[3]),
    .A4(PADDR[2]),
    .ZN(_170_)
  );
  INV_X1 _457_ (
    .A(_170_),
    .ZN(_171_)
  );
  NAND2_X1 _458_ (
    .A1(PADDR[3]),
    .A2(_166_),
    .ZN(_172_)
  );
  AND3_X1 _459_ (
    .A1(PADDR[3]),
    .A2(_166_),
    .A3(_169_),
    .ZN(_173_)
  );
  NOR4_X1 _460_ (
    .A1(PADDR[4]),
    .A2(_165_),
    .A3(PADDR[3]),
    .A4(PADDR[2]),
    .ZN(_174_)
  );
  AND3_X1 _461_ (
    .A1(PADDR[3]),
    .A2(PADDR[2]),
    .A3(_169_),
    .ZN(_175_)
  );
  NOR4_X1 _462_ (
    .A1(_164_),
    .A2(PADDR[5]),
    .A3(PADDR[3]),
    .A4(PADDR[2]),
    .ZN(_176_)
  );
  AOI22_X1 _463_ (
    .A1(spi_dummy_wr[6]),
    .A2(_168_),
    .B1(_176_),
    .B2(spi_data_len[6]),
    .ZN(_177_)
  );
  AOI22_X1 _464_ (
    .A1(spi_cmd[22]),
    .A2(_173_),
    .B1(_175_),
    .B2(spi_addr[22]),
    .ZN(_178_)
  );
  AOI22_X1 _465_ (
    .A1(spi_status[22]),
    .A2(_170_),
    .B1(_174_),
    .B2(spi_data_rx[22]),
    .ZN(_179_)
  );
  NAND3_X1 _466_ (
    .A1(_177_),
    .A2(_178_),
    .A3(_179_),
    .ZN(PRDATA[22])
  );
  AOI22_X1 _467_ (
    .A1(spi_status[21]),
    .A2(_170_),
    .B1(_173_),
    .B2(spi_cmd[21]),
    .ZN(_180_)
  );
  AOI22_X1 _468_ (
    .A1(spi_addr[21]),
    .A2(_175_),
    .B1(_176_),
    .B2(spi_data_len[5]),
    .ZN(_181_)
  );
  AOI22_X1 _469_ (
    .A1(spi_dummy_wr[5]),
    .A2(_168_),
    .B1(_174_),
    .B2(spi_data_rx[21]),
    .ZN(_182_)
  );
  NAND3_X1 _470_ (
    .A1(_180_),
    .A2(_181_),
    .A3(_182_),
    .ZN(PRDATA[21])
  );
  AOI22_X1 _471_ (
    .A1(spi_data_rx[19]),
    .A2(_174_),
    .B1(_175_),
    .B2(spi_addr[19]),
    .ZN(_183_)
  );
  NOR4_X1 _472_ (
    .A1(PADDR[4]),
    .A2(_165_),
    .A3(PADDR[3]),
    .A4(_166_),
    .ZN(_184_)
  );
  AOI222_X1 _473_ (
    .A1(spi_status[19]),
    .A2(_170_),
    .B1(_173_),
    .B2(spi_cmd[19]),
    .C1(spi_int_cnt_tx[3]),
    .C2(_184_),
    .ZN(_185_)
  );
  AOI22_X1 _474_ (
    .A1(spi_dummy_wr[3]),
    .A2(_168_),
    .B1(_176_),
    .B2(spi_data_len[3]),
    .ZN(_186_)
  );
  NAND3_X1 _475_ (
    .A1(_183_),
    .A2(_185_),
    .A3(_186_),
    .ZN(PRDATA[19])
  );
  AOI22_X1 _476_ (
    .A1(spi_status[18]),
    .A2(_170_),
    .B1(_175_),
    .B2(spi_addr[18]),
    .ZN(_187_)
  );
  AOI222_X1 _477_ (
    .A1(spi_cmd[18]),
    .A2(_173_),
    .B1(_176_),
    .B2(spi_data_len[2]),
    .C1(_184_),
    .C2(spi_int_cnt_tx[2]),
    .ZN(_188_)
  );
  AOI22_X1 _478_ (
    .A1(spi_dummy_wr[2]),
    .A2(_168_),
    .B1(_174_),
    .B2(spi_data_rx[18]),
    .ZN(_189_)
  );
  NAND3_X1 _479_ (
    .A1(_187_),
    .A2(_188_),
    .A3(_189_),
    .ZN(PRDATA[18])
  );
  AOI22_X1 _480_ (
    .A1(spi_dummy_wr[1]),
    .A2(_168_),
    .B1(_170_),
    .B2(spi_status[17]),
    .ZN(_190_)
  );
  AOI222_X1 _481_ (
    .A1(spi_cmd[17]),
    .A2(_173_),
    .B1(_176_),
    .B2(spi_data_len[1]),
    .C1(_184_),
    .C2(spi_int_cnt_tx[1]),
    .ZN(_191_)
  );
  AOI22_X1 _482_ (
    .A1(spi_data_rx[17]),
    .A2(_174_),
    .B1(_175_),
    .B2(spi_addr[17]),
    .ZN(_192_)
  );
  NAND3_X1 _483_ (
    .A1(_190_),
    .A2(_191_),
    .A3(_192_),
    .ZN(PRDATA[17])
  );
  AOI222_X1 _484_ (
    .A1(spi_status[16]),
    .A2(_170_),
    .B1(_174_),
    .B2(spi_data_rx[16]),
    .C1(spi_dummy_wr[0]),
    .C2(_168_),
    .ZN(_193_)
  );
  AOI22_X1 _485_ (
    .A1(spi_cmd[16]),
    .A2(_173_),
    .B1(_184_),
    .B2(spi_int_cnt_tx[0]),
    .ZN(_194_)
  );
  AOI22_X1 _486_ (
    .A1(spi_addr[16]),
    .A2(_175_),
    .B1(_176_),
    .B2(spi_data_len[0]),
    .ZN(_195_)
  );
  NAND3_X1 _487_ (
    .A1(_193_),
    .A2(_194_),
    .A3(_195_),
    .ZN(PRDATA[16])
  );
  AOI22_X1 _488_ (
    .A1(spi_status[27]),
    .A2(_170_),
    .B1(_176_),
    .B2(spi_data_len[11]),
    .ZN(_196_)
  );
  AOI222_X1 _489_ (
    .A1(spi_dummy_wr[11]),
    .A2(_168_),
    .B1(_173_),
    .B2(spi_cmd[27]),
    .C1(_175_),
    .C2(spi_addr[27]),
    .ZN(_197_)
  );
  AOI22_X1 _490_ (
    .A1(spi_data_rx[27]),
    .A2(_174_),
    .B1(_184_),
    .B2(spi_int_cnt_rx[3]),
    .ZN(_198_)
  );
  NAND3_X1 _491_ (
    .A1(_196_),
    .A2(_197_),
    .A3(_198_),
    .ZN(PRDATA[27])
  );
  AOI22_X1 _492_ (
    .A1(spi_status[14]),
    .A2(_170_),
    .B1(_173_),
    .B2(spi_cmd[14]),
    .ZN(_199_)
  );
  AOI222_X1 _493_ (
    .A1(spi_dummy_rd[14]),
    .A2(_168_),
    .B1(_174_),
    .B2(spi_data_rx[14]),
    .C1(_175_),
    .C2(spi_addr[14]),
    .ZN(_200_)
  );
  NAND2_X1 _494_ (
    .A1(_199_),
    .A2(_200_),
    .ZN(PRDATA[14])
  );
  AOI22_X1 _495_ (
    .A1(spi_status[13]),
    .A2(_170_),
    .B1(_173_),
    .B2(spi_cmd[13]),
    .ZN(_201_)
  );
  AOI22_X1 _496_ (
    .A1(spi_addr[13]),
    .A2(_175_),
    .B1(_176_),
    .B2(spi_addr_len[5]),
    .ZN(_202_)
  );
  AOI22_X1 _497_ (
    .A1(spi_dummy_rd[13]),
    .A2(_168_),
    .B1(_174_),
    .B2(spi_data_rx[13]),
    .ZN(_203_)
  );
  NAND3_X1 _498_ (
    .A1(_201_),
    .A2(_202_),
    .A3(_203_),
    .ZN(PRDATA[13])
  );
  AOI222_X1 _499_ (
    .A1(spi_status[26]),
    .A2(_170_),
    .B1(_174_),
    .B2(spi_data_rx[26]),
    .C1(_184_),
    .C2(spi_int_cnt_rx[2]),
    .ZN(_204_)
  );
  AOI22_X1 _500_ (
    .A1(spi_cmd[26]),
    .A2(_173_),
    .B1(_176_),
    .B2(spi_data_len[10]),
    .ZN(_205_)
  );
  AOI22_X1 _501_ (
    .A1(spi_dummy_wr[10]),
    .A2(_168_),
    .B1(_175_),
    .B2(spi_addr[26]),
    .ZN(_206_)
  );
  NAND3_X1 _502_ (
    .A1(_204_),
    .A2(_205_),
    .A3(_206_),
    .ZN(PRDATA[26])
  );
  AOI22_X1 _503_ (
    .A1(spi_dummy_rd[11]),
    .A2(_168_),
    .B1(_170_),
    .B2(spi_status[11]),
    .ZN(_207_)
  );
  AOI222_X1 _504_ (
    .A1(spi_cmd[11]),
    .A2(_173_),
    .B1(_176_),
    .B2(spi_addr_len[3]),
    .C1(_174_),
    .C2(spi_data_rx[11]),
    .ZN(_208_)
  );
  AOI22_X1 _505_ (
    .A1(spi_addr[11]),
    .A2(_175_),
    .B1(_184_),
    .B2(spi_int_th_rx[3]),
    .ZN(_209_)
  );
  NAND3_X1 _506_ (
    .A1(_207_),
    .A2(_208_),
    .A3(_209_),
    .ZN(PRDATA[11])
  );
  AOI22_X1 _507_ (
    .A1(spi_status[10]),
    .A2(_170_),
    .B1(_173_),
    .B2(spi_cmd[10]),
    .ZN(_210_)
  );
  AOI222_X1 _508_ (
    .A1(spi_addr[10]),
    .A2(_175_),
    .B1(_176_),
    .B2(spi_addr_len[2]),
    .C1(spi_data_rx[10]),
    .C2(_174_),
    .ZN(_211_)
  );
  AOI22_X1 _509_ (
    .A1(spi_dummy_rd[10]),
    .A2(_168_),
    .B1(_184_),
    .B2(spi_int_th_rx[2]),
    .ZN(_212_)
  );
  NAND3_X1 _510_ (
    .A1(_210_),
    .A2(_211_),
    .A3(_212_),
    .ZN(PRDATA[10])
  );
  AOI22_X1 _511_ (
    .A1(spi_status[9]),
    .A2(_170_),
    .B1(_176_),
    .B2(spi_addr_len[1]),
    .ZN(_213_)
  );
  AOI222_X1 _512_ (
    .A1(spi_dummy_rd[9]),
    .A2(_168_),
    .B1(_173_),
    .B2(spi_cmd[9]),
    .C1(spi_data_rx[9]),
    .C2(_174_),
    .ZN(_214_)
  );
  AOI22_X1 _513_ (
    .A1(spi_addr[9]),
    .A2(_175_),
    .B1(_184_),
    .B2(spi_int_th_rx[1]),
    .ZN(_215_)
  );
  NAND3_X1 _514_ (
    .A1(_213_),
    .A2(_214_),
    .A3(_215_),
    .ZN(PRDATA[9])
  );
  AOI22_X1 _515_ (
    .A1(spi_dummy_rd[8]),
    .A2(_168_),
    .B1(_170_),
    .B2(spi_status[8]),
    .ZN(_216_)
  );
  AOI222_X1 _516_ (
    .A1(spi_cmd[8]),
    .A2(_173_),
    .B1(_174_),
    .B2(spi_data_rx[8]),
    .C1(_184_),
    .C2(spi_int_th_rx[0]),
    .ZN(_217_)
  );
  AOI22_X1 _517_ (
    .A1(spi_addr[8]),
    .A2(_175_),
    .B1(_176_),
    .B2(spi_addr_len[0]),
    .ZN(_218_)
  );
  NAND3_X1 _518_ (
    .A1(_216_),
    .A2(_217_),
    .A3(_218_),
    .ZN(PRDATA[8])
  );
  AOI22_X1 _519_ (
    .A1(spi_data_rx[25]),
    .A2(_174_),
    .B1(_175_),
    .B2(spi_addr[25]),
    .ZN(_219_)
  );
  AOI222_X1 _520_ (
    .A1(spi_dummy_wr[9]),
    .A2(_168_),
    .B1(_170_),
    .B2(spi_status[25]),
    .C1(spi_int_cnt_rx[1]),
    .C2(_184_),
    .ZN(_220_)
  );
  AOI22_X1 _521_ (
    .A1(spi_cmd[25]),
    .A2(_173_),
    .B1(_176_),
    .B2(spi_data_len[9]),
    .ZN(_221_)
  );
  NAND3_X1 _522_ (
    .A1(_219_),
    .A2(_220_),
    .A3(_221_),
    .ZN(PRDATA[25])
  );
  AOI222_X1 _523_ (
    .A1(spi_status[24]),
    .A2(_170_),
    .B1(_173_),
    .B2(spi_cmd[24]),
    .C1(spi_dummy_wr[8]),
    .C2(_168_),
    .ZN(_222_)
  );
  AOI22_X1 _524_ (
    .A1(spi_data_rx[24]),
    .A2(_174_),
    .B1(_184_),
    .B2(spi_int_cnt_rx[0]),
    .ZN(_223_)
  );
  AOI22_X1 _525_ (
    .A1(spi_addr[24]),
    .A2(_175_),
    .B1(_176_),
    .B2(spi_data_len[8]),
    .ZN(_224_)
  );
  NAND3_X1 _526_ (
    .A1(_222_),
    .A2(_223_),
    .A3(_224_),
    .ZN(PRDATA[24])
  );
  NOR4_X1 _527_ (
    .A1(PADDR[4]),
    .A2(PADDR[5]),
    .A3(PADDR[3]),
    .A4(_166_),
    .ZN(_225_)
  );
  AOI22_X1 _528_ (
    .A1(spi_cmd[6]),
    .A2(_173_),
    .B1(_225_),
    .B2(spi_clk_div[6]),
    .ZN(_226_)
  );
  AOI22_X1 _529_ (
    .A1(spi_status[6]),
    .A2(_170_),
    .B1(_175_),
    .B2(spi_addr[6]),
    .ZN(_227_)
  );
  AOI22_X1 _530_ (
    .A1(spi_dummy_rd[6]),
    .A2(_168_),
    .B1(_174_),
    .B2(spi_data_rx[6]),
    .ZN(_228_)
  );
  NAND3_X1 _531_ (
    .A1(_226_),
    .A2(_227_),
    .A3(_228_),
    .ZN(PRDATA[6])
  );
  AOI222_X1 _532_ (
    .A1(spi_dummy_rd[5]),
    .A2(_168_),
    .B1(_173_),
    .B2(spi_cmd[5]),
    .C1(spi_clk_div[5]),
    .C2(_225_),
    .ZN(_229_)
  );
  AOI22_X1 _533_ (
    .A1(spi_status[5]),
    .A2(_170_),
    .B1(_174_),
    .B2(spi_data_rx[5]),
    .ZN(_230_)
  );
  AOI22_X1 _534_ (
    .A1(spi_addr[5]),
    .A2(_175_),
    .B1(_176_),
    .B2(spi_cmd_len[5]),
    .ZN(_231_)
  );
  NAND3_X1 _535_ (
    .A1(_229_),
    .A2(_230_),
    .A3(_231_),
    .ZN(PRDATA[5])
  );
  AOI22_X1 _536_ (
    .A1(spi_cmd[3]),
    .A2(_173_),
    .B1(_225_),
    .B2(spi_clk_div[3]),
    .ZN(_232_)
  );
  AOI22_X1 _537_ (
    .A1(spi_addr[3]),
    .A2(_175_),
    .B1(_184_),
    .B2(spi_int_th_tx[3]),
    .ZN(_233_)
  );
  AOI22_X1 _538_ (
    .A1(spi_dummy_rd[3]),
    .A2(_168_),
    .B1(_176_),
    .B2(spi_cmd_len[3]),
    .ZN(_234_)
  );
  AOI22_X1 _539_ (
    .A1(spi_status[3]),
    .A2(_170_),
    .B1(_174_),
    .B2(spi_data_rx[3]),
    .ZN(_235_)
  );
  NAND4_X1 _540_ (
    .A1(_232_),
    .A2(_233_),
    .A3(_234_),
    .A4(_235_),
    .ZN(PRDATA[3])
  );
  AOI22_X1 _541_ (
    .A1(spi_addr[2]),
    .A2(_175_),
    .B1(_176_),
    .B2(spi_cmd_len[2]),
    .ZN(_236_)
  );
  AOI22_X1 _542_ (
    .A1(spi_cmd[2]),
    .A2(_173_),
    .B1(_174_),
    .B2(spi_data_rx[2]),
    .ZN(_237_)
  );
  AOI22_X1 _543_ (
    .A1(spi_status[2]),
    .A2(_170_),
    .B1(_225_),
    .B2(spi_clk_div[2]),
    .ZN(_238_)
  );
  AOI22_X1 _544_ (
    .A1(spi_dummy_rd[2]),
    .A2(_168_),
    .B1(_184_),
    .B2(spi_int_th_tx[2]),
    .ZN(_239_)
  );
  NAND4_X1 _545_ (
    .A1(_236_),
    .A2(_237_),
    .A3(_238_),
    .A4(_239_),
    .ZN(PRDATA[2])
  );
  AOI22_X1 _546_ (
    .A1(spi_status[1]),
    .A2(_170_),
    .B1(_175_),
    .B2(spi_addr[1]),
    .ZN(_240_)
  );
  AOI22_X1 _547_ (
    .A1(spi_dummy_rd[1]),
    .A2(_168_),
    .B1(_174_),
    .B2(spi_data_rx[1]),
    .ZN(_241_)
  );
  AOI22_X1 _548_ (
    .A1(spi_cmd_len[1]),
    .A2(_176_),
    .B1(_225_),
    .B2(spi_clk_div[1]),
    .ZN(_242_)
  );
  AOI22_X1 _549_ (
    .A1(spi_cmd[1]),
    .A2(_173_),
    .B1(_184_),
    .B2(spi_int_th_tx[1]),
    .ZN(_243_)
  );
  NAND4_X1 _550_ (
    .A1(_240_),
    .A2(_241_),
    .A3(_242_),
    .A4(_243_),
    .ZN(PRDATA[1])
  );
  AOI22_X1 _551_ (
    .A1(spi_dummy_rd[0]),
    .A2(_168_),
    .B1(_176_),
    .B2(spi_cmd_len[0]),
    .ZN(_244_)
  );
  AOI22_X1 _552_ (
    .A1(spi_addr[0]),
    .A2(_175_),
    .B1(_184_),
    .B2(spi_int_th_tx[0]),
    .ZN(_245_)
  );
  AOI22_X1 _553_ (
    .A1(spi_status[0]),
    .A2(_170_),
    .B1(_225_),
    .B2(spi_clk_div[0]),
    .ZN(_246_)
  );
  AOI22_X1 _554_ (
    .A1(spi_cmd[0]),
    .A2(_173_),
    .B1(_174_),
    .B2(spi_data_rx[0]),
    .ZN(_247_)
  );
  NAND4_X1 _555_ (
    .A1(_244_),
    .A2(_245_),
    .A3(_246_),
    .A4(_247_),
    .ZN(PRDATA[0])
  );
  AOI22_X1 _556_ (
    .A1(spi_cmd[30]),
    .A2(_173_),
    .B1(_176_),
    .B2(spi_data_len[14]),
    .ZN(_248_)
  );
  AOI222_X1 _557_ (
    .A1(spi_status[30]),
    .A2(_170_),
    .B1(_175_),
    .B2(spi_addr[30]),
    .C1(spi_int_cnt_en),
    .C2(_184_),
    .ZN(_249_)
  );
  AOI22_X1 _558_ (
    .A1(spi_dummy_wr[14]),
    .A2(_168_),
    .B1(_174_),
    .B2(spi_data_rx[30]),
    .ZN(_250_)
  );
  NAND3_X1 _559_ (
    .A1(_248_),
    .A2(_249_),
    .A3(_250_),
    .ZN(PRDATA[30])
  );
  AOI22_X1 _560_ (
    .A1(spi_int_th_tx[4]),
    .A2(_184_),
    .B1(_225_),
    .B2(spi_clk_div[4]),
    .ZN(_251_)
  );
  AOI22_X1 _561_ (
    .A1(spi_cmd[4]),
    .A2(_173_),
    .B1(_176_),
    .B2(spi_cmd_len[4]),
    .ZN(_252_)
  );
  AOI22_X1 _562_ (
    .A1(spi_status[4]),
    .A2(_170_),
    .B1(_174_),
    .B2(spi_data_rx[4]),
    .ZN(_253_)
  );
  AOI22_X1 _563_ (
    .A1(spi_dummy_rd[4]),
    .A2(_168_),
    .B1(_175_),
    .B2(spi_addr[4]),
    .ZN(_254_)
  );
  NAND4_X1 _564_ (
    .A1(_251_),
    .A2(_252_),
    .A3(_253_),
    .A4(_254_),
    .ZN(PRDATA[4])
  );
  AOI22_X1 _565_ (
    .A1(spi_dummy_rd[7]),
    .A2(_168_),
    .B1(_173_),
    .B2(spi_cmd[7]),
    .ZN(_255_)
  );
  AOI22_X1 _566_ (
    .A1(spi_data_rx[7]),
    .A2(_174_),
    .B1(_225_),
    .B2(spi_clk_div[7]),
    .ZN(_256_)
  );
  AOI22_X1 _567_ (
    .A1(spi_status[7]),
    .A2(_170_),
    .B1(_175_),
    .B2(spi_addr[7]),
    .ZN(_257_)
  );
  NAND3_X1 _568_ (
    .A1(_255_),
    .A2(_256_),
    .A3(_257_),
    .ZN(PRDATA[7])
  );
  AOI22_X1 _569_ (
    .A1(spi_status[12]),
    .A2(_170_),
    .B1(_176_),
    .B2(spi_addr_len[4]),
    .ZN(_258_)
  );
  AOI222_X1 _570_ (
    .A1(spi_dummy_rd[12]),
    .A2(_168_),
    .B1(_173_),
    .B2(spi_cmd[12]),
    .C1(spi_data_rx[12]),
    .C2(_174_),
    .ZN(_259_)
  );
  AOI22_X1 _571_ (
    .A1(spi_addr[12]),
    .A2(_175_),
    .B1(_184_),
    .B2(spi_int_th_rx[4]),
    .ZN(_260_)
  );
  NAND3_X1 _572_ (
    .A1(_258_),
    .A2(_259_),
    .A3(_260_),
    .ZN(PRDATA[12])
  );
  AOI22_X1 _573_ (
    .A1(spi_dummy_rd[15]),
    .A2(_168_),
    .B1(_175_),
    .B2(spi_addr[15]),
    .ZN(_261_)
  );
  AOI222_X1 _574_ (
    .A1(spi_status[15]),
    .A2(_170_),
    .B1(_173_),
    .B2(spi_cmd[15]),
    .C1(_174_),
    .C2(spi_data_rx[15]),
    .ZN(_262_)
  );
  NAND2_X1 _575_ (
    .A1(_261_),
    .A2(_262_),
    .ZN(PRDATA[15])
  );
  AOI22_X1 _576_ (
    .A1(spi_status[20]),
    .A2(_170_),
    .B1(_175_),
    .B2(spi_addr[20]),
    .ZN(_263_)
  );
  AOI222_X1 _577_ (
    .A1(spi_cmd[20]),
    .A2(_173_),
    .B1(_176_),
    .B2(spi_data_len[4]),
    .C1(_184_),
    .C2(spi_int_cnt_tx[4]),
    .ZN(_264_)
  );
  AOI22_X1 _578_ (
    .A1(spi_dummy_wr[4]),
    .A2(_168_),
    .B1(_174_),
    .B2(spi_data_rx[20]),
    .ZN(_265_)
  );
  NAND3_X1 _579_ (
    .A1(_263_),
    .A2(_264_),
    .A3(_265_),
    .ZN(PRDATA[20])
  );
  AOI22_X1 _580_ (
    .A1(spi_status[23]),
    .A2(_170_),
    .B1(_173_),
    .B2(spi_cmd[23]),
    .ZN(_266_)
  );
  AOI22_X1 _581_ (
    .A1(spi_addr[23]),
    .A2(_175_),
    .B1(_176_),
    .B2(spi_data_len[7]),
    .ZN(_267_)
  );
  AOI22_X1 _582_ (
    .A1(spi_dummy_wr[7]),
    .A2(_168_),
    .B1(_174_),
    .B2(spi_data_rx[23]),
    .ZN(_268_)
  );
  NAND3_X1 _583_ (
    .A1(_266_),
    .A2(_267_),
    .A3(_268_),
    .ZN(PRDATA[23])
  );
  AOI22_X1 _584_ (
    .A1(spi_dummy_wr[12]),
    .A2(_168_),
    .B1(_170_),
    .B2(spi_status[28]),
    .ZN(_269_)
  );
  AOI222_X1 _585_ (
    .A1(spi_cmd[28]),
    .A2(_173_),
    .B1(_174_),
    .B2(spi_data_rx[28]),
    .C1(_184_),
    .C2(spi_int_cnt_rx[4]),
    .ZN(_270_)
  );
  AOI22_X1 _586_ (
    .A1(spi_addr[28]),
    .A2(_175_),
    .B1(_176_),
    .B2(spi_data_len[12]),
    .ZN(_271_)
  );
  NAND3_X1 _587_ (
    .A1(_269_),
    .A2(_270_),
    .A3(_271_),
    .ZN(PRDATA[28])
  );
  AOI22_X1 _588_ (
    .A1(spi_data_rx[29]),
    .A2(_174_),
    .B1(_176_),
    .B2(spi_data_len[13]),
    .ZN(_272_)
  );
  AOI22_X1 _589_ (
    .A1(spi_status[29]),
    .A2(_170_),
    .B1(_175_),
    .B2(spi_addr[29]),
    .ZN(_273_)
  );
  AOI22_X1 _590_ (
    .A1(spi_dummy_wr[13]),
    .A2(_168_),
    .B1(_173_),
    .B2(spi_cmd[29]),
    .ZN(_274_)
  );
  NAND3_X1 _591_ (
    .A1(_272_),
    .A2(_273_),
    .A3(_274_),
    .ZN(PRDATA[29])
  );
  AOI22_X1 _592_ (
    .A1(spi_status[31]),
    .A2(_170_),
    .B1(_175_),
    .B2(spi_addr[31]),
    .ZN(_275_)
  );
  AOI222_X1 _593_ (
    .A1(spi_dummy_wr[15]),
    .A2(_168_),
    .B1(_173_),
    .B2(spi_cmd[31]),
    .C1(spi_int_en),
    .C2(_184_),
    .ZN(_276_)
  );
  AOI22_X1 _594_ (
    .A1(spi_data_rx[31]),
    .A2(_174_),
    .B1(_176_),
    .B2(spi_data_len[15]),
    .ZN(_277_)
  );
  NAND3_X1 _595_ (
    .A1(_275_),
    .A2(_276_),
    .A3(_277_),
    .ZN(PRDATA[31])
  );
  NAND3_X1 _596_ (
    .A1(PSEL),
    .A2(PENABLE),
    .A3(PWRITE),
    .ZN(_278_)
  );
  AND4_X1 _597_ (
    .A1(PSEL),
    .A2(PENABLE),
    .A3(PWRITE),
    .A4(_225_),
    .ZN(_000_)
  );
  NOR2_X1 _598_ (
    .A1(_171_),
    .A2(_278_),
    .ZN(_279_)
  );
  AND2_X1 _599_ (
    .A1(PWDATA[4]),
    .A2(_279_),
    .ZN(_004_)
  );
  AND2_X1 _600_ (
    .A1(PWDATA[0]),
    .A2(_279_),
    .ZN(_003_)
  );
  AND2_X1 _601_ (
    .A1(PWDATA[1]),
    .A2(_279_),
    .ZN(_005_)
  );
  AND2_X1 _602_ (
    .A1(PWDATA[2]),
    .A2(_279_),
    .ZN(_001_)
  );
  AND2_X1 _603_ (
    .A1(PWDATA[3]),
    .A2(_279_),
    .ZN(_002_)
  );
  NAND3_X1 _604_ (
    .A1(PSEL),
    .A2(PENABLE),
    .A3(_167_),
    .ZN(_280_)
  );
  AND4_X1 _605_ (
    .A1(PSEL),
    .A2(PENABLE),
    .A3(_167_),
    .A4(_174_),
    .ZN(spi_data_rx_ready)
  );
  NOR4_X1 _606_ (
    .A1(_164_),
    .A2(PADDR[5]),
    .A3(_172_),
    .A4(_278_),
    .ZN(spi_data_tx_valid)
  );
  NOR4_X1 _607_ (
    .A1(PADDR[4]),
    .A2(_165_),
    .A3(_172_),
    .A4(_280_),
    .ZN(spi_int_rd_sta)
  );
  AND4_X1 _608_ (
    .A1(PSEL),
    .A2(PENABLE),
    .A3(PWRITE),
    .A4(_175_),
    .ZN(_281_)
  );
  MUX2_X1 _609_ (
    .A(spi_addr[20]),
    .B(PWDATA[20]),
    .S(_281_),
    .Z(_006_)
  );
  MUX2_X1 _610_ (
    .A(spi_addr[19]),
    .B(PWDATA[19]),
    .S(_281_),
    .Z(_007_)
  );
  MUX2_X1 _611_ (
    .A(spi_addr[18]),
    .B(PWDATA[18]),
    .S(_281_),
    .Z(_008_)
  );
  MUX2_X1 _612_ (
    .A(spi_addr[17]),
    .B(PWDATA[17]),
    .S(_281_),
    .Z(_009_)
  );
  MUX2_X1 _613_ (
    .A(spi_addr[16]),
    .B(PWDATA[16]),
    .S(_281_),
    .Z(_010_)
  );
  MUX2_X1 _614_ (
    .A(spi_addr[15]),
    .B(PWDATA[15]),
    .S(_281_),
    .Z(_011_)
  );
  MUX2_X1 _615_ (
    .A(spi_addr[14]),
    .B(PWDATA[14]),
    .S(_281_),
    .Z(_012_)
  );
  MUX2_X1 _616_ (
    .A(spi_addr[13]),
    .B(PWDATA[13]),
    .S(_281_),
    .Z(_013_)
  );
  MUX2_X1 _617_ (
    .A(spi_addr[12]),
    .B(PWDATA[12]),
    .S(_281_),
    .Z(_014_)
  );
  MUX2_X1 _618_ (
    .A(spi_addr[11]),
    .B(PWDATA[11]),
    .S(_281_),
    .Z(_015_)
  );
  MUX2_X1 _619_ (
    .A(spi_addr[10]),
    .B(PWDATA[10]),
    .S(_281_),
    .Z(_016_)
  );
  MUX2_X1 _620_ (
    .A(spi_addr[9]),
    .B(PWDATA[9]),
    .S(_281_),
    .Z(_017_)
  );
  MUX2_X1 _621_ (
    .A(spi_addr[8]),
    .B(PWDATA[8]),
    .S(_281_),
    .Z(_018_)
  );
  MUX2_X1 _622_ (
    .A(spi_addr[7]),
    .B(PWDATA[7]),
    .S(_281_),
    .Z(_019_)
  );
  MUX2_X1 _623_ (
    .A(spi_addr[6]),
    .B(PWDATA[6]),
    .S(_281_),
    .Z(_020_)
  );
  MUX2_X1 _624_ (
    .A(spi_addr[5]),
    .B(PWDATA[5]),
    .S(_281_),
    .Z(_021_)
  );
  MUX2_X1 _625_ (
    .A(spi_addr[4]),
    .B(PWDATA[4]),
    .S(_281_),
    .Z(_022_)
  );
  MUX2_X1 _626_ (
    .A(spi_addr[3]),
    .B(PWDATA[3]),
    .S(_281_),
    .Z(_023_)
  );
  MUX2_X1 _627_ (
    .A(spi_addr[2]),
    .B(PWDATA[2]),
    .S(_281_),
    .Z(_024_)
  );
  MUX2_X1 _628_ (
    .A(spi_addr[1]),
    .B(PWDATA[1]),
    .S(_281_),
    .Z(_025_)
  );
  MUX2_X1 _629_ (
    .A(spi_addr[0]),
    .B(PWDATA[0]),
    .S(_281_),
    .Z(_026_)
  );
  NAND4_X1 _630_ (
    .A1(PSEL),
    .A2(PENABLE),
    .A3(PWRITE),
    .A4(_176_),
    .ZN(_282_)
  );
  MUX2_X1 _631_ (
    .A(PWDATA[12]),
    .B(spi_addr_len[4]),
    .S(_282_),
    .Z(_027_)
  );
  MUX2_X1 _632_ (
    .A(PWDATA[11]),
    .B(spi_addr_len[3]),
    .S(_282_),
    .Z(_028_)
  );
  MUX2_X1 _633_ (
    .A(PWDATA[10]),
    .B(spi_addr_len[2]),
    .S(_282_),
    .Z(_029_)
  );
  MUX2_X1 _634_ (
    .A(PWDATA[9]),
    .B(spi_addr_len[1]),
    .S(_282_),
    .Z(_030_)
  );
  MUX2_X1 _635_ (
    .A(PWDATA[8]),
    .B(spi_addr_len[0]),
    .S(_282_),
    .Z(_031_)
  );
  AND4_X1 _636_ (
    .A1(PSEL),
    .A2(PENABLE),
    .A3(PWRITE),
    .A4(_184_),
    .ZN(_283_)
  );
  MUX2_X1 _637_ (
    .A(spi_int_th_tx[3]),
    .B(PWDATA[3]),
    .S(_283_),
    .Z(_032_)
  );
  MUX2_X1 _638_ (
    .A(spi_int_th_tx[2]),
    .B(PWDATA[2]),
    .S(_283_),
    .Z(_033_)
  );
  MUX2_X1 _639_ (
    .A(spi_int_th_tx[1]),
    .B(PWDATA[1]),
    .S(_283_),
    .Z(_034_)
  );
  MUX2_X1 _640_ (
    .A(spi_int_th_tx[0]),
    .B(PWDATA[0]),
    .S(_283_),
    .Z(_035_)
  );
  NOR4_X1 _641_ (
    .A1(PADDR[4]),
    .A2(PADDR[5]),
    .A3(_172_),
    .A4(_278_),
    .ZN(_284_)
  );
  MUX2_X1 _642_ (
    .A(spi_cmd[30]),
    .B(PWDATA[30]),
    .S(_284_),
    .Z(_036_)
  );
  MUX2_X1 _643_ (
    .A(spi_cmd[29]),
    .B(PWDATA[29]),
    .S(_284_),
    .Z(_037_)
  );
  MUX2_X1 _644_ (
    .A(spi_cmd[28]),
    .B(PWDATA[28]),
    .S(_284_),
    .Z(_038_)
  );
  MUX2_X1 _645_ (
    .A(spi_cmd[27]),
    .B(PWDATA[27]),
    .S(_284_),
    .Z(_039_)
  );
  MUX2_X1 _646_ (
    .A(spi_cmd[26]),
    .B(PWDATA[26]),
    .S(_284_),
    .Z(_040_)
  );
  MUX2_X1 _647_ (
    .A(spi_cmd[25]),
    .B(PWDATA[25]),
    .S(_284_),
    .Z(_041_)
  );
  MUX2_X1 _648_ (
    .A(spi_cmd[24]),
    .B(PWDATA[24]),
    .S(_284_),
    .Z(_042_)
  );
  MUX2_X1 _649_ (
    .A(spi_cmd[23]),
    .B(PWDATA[23]),
    .S(_284_),
    .Z(_043_)
  );
  MUX2_X1 _650_ (
    .A(spi_cmd[22]),
    .B(PWDATA[22]),
    .S(_284_),
    .Z(_044_)
  );
  MUX2_X1 _651_ (
    .A(spi_cmd[21]),
    .B(PWDATA[21]),
    .S(_284_),
    .Z(_045_)
  );
  MUX2_X1 _652_ (
    .A(spi_cmd[20]),
    .B(PWDATA[20]),
    .S(_284_),
    .Z(_046_)
  );
  MUX2_X1 _653_ (
    .A(spi_cmd[19]),
    .B(PWDATA[19]),
    .S(_284_),
    .Z(_047_)
  );
  MUX2_X1 _654_ (
    .A(spi_cmd[18]),
    .B(PWDATA[18]),
    .S(_284_),
    .Z(_048_)
  );
  MUX2_X1 _655_ (
    .A(spi_cmd[17]),
    .B(PWDATA[17]),
    .S(_284_),
    .Z(_049_)
  );
  MUX2_X1 _656_ (
    .A(spi_cmd[16]),
    .B(PWDATA[16]),
    .S(_284_),
    .Z(_050_)
  );
  MUX2_X1 _657_ (
    .A(spi_cmd[15]),
    .B(PWDATA[15]),
    .S(_284_),
    .Z(_051_)
  );
  MUX2_X1 _658_ (
    .A(spi_cmd[14]),
    .B(PWDATA[14]),
    .S(_284_),
    .Z(_052_)
  );
  MUX2_X1 _659_ (
    .A(spi_cmd[13]),
    .B(PWDATA[13]),
    .S(_284_),
    .Z(_053_)
  );
  MUX2_X1 _660_ (
    .A(spi_cmd[12]),
    .B(PWDATA[12]),
    .S(_284_),
    .Z(_054_)
  );
  MUX2_X1 _661_ (
    .A(spi_cmd[11]),
    .B(PWDATA[11]),
    .S(_284_),
    .Z(_055_)
  );
  MUX2_X1 _662_ (
    .A(spi_cmd[10]),
    .B(PWDATA[10]),
    .S(_284_),
    .Z(_056_)
  );
  MUX2_X1 _663_ (
    .A(spi_cmd[9]),
    .B(PWDATA[9]),
    .S(_284_),
    .Z(_057_)
  );
  MUX2_X1 _664_ (
    .A(spi_cmd[8]),
    .B(PWDATA[8]),
    .S(_284_),
    .Z(_058_)
  );
  MUX2_X1 _665_ (
    .A(spi_cmd[7]),
    .B(PWDATA[7]),
    .S(_284_),
    .Z(_059_)
  );
  MUX2_X1 _666_ (
    .A(spi_cmd[6]),
    .B(PWDATA[6]),
    .S(_284_),
    .Z(_060_)
  );
  MUX2_X1 _667_ (
    .A(spi_cmd[5]),
    .B(PWDATA[5]),
    .S(_284_),
    .Z(_061_)
  );
  MUX2_X1 _668_ (
    .A(spi_cmd[4]),
    .B(PWDATA[4]),
    .S(_284_),
    .Z(_062_)
  );
  MUX2_X1 _669_ (
    .A(spi_cmd[3]),
    .B(PWDATA[3]),
    .S(_284_),
    .Z(_063_)
  );
  MUX2_X1 _670_ (
    .A(spi_cmd[2]),
    .B(PWDATA[2]),
    .S(_284_),
    .Z(_064_)
  );
  MUX2_X1 _671_ (
    .A(spi_cmd[1]),
    .B(PWDATA[1]),
    .S(_284_),
    .Z(_065_)
  );
  MUX2_X1 _672_ (
    .A(spi_cmd[0]),
    .B(PWDATA[0]),
    .S(_284_),
    .Z(_066_)
  );
  AND4_X1 _673_ (
    .A1(PSEL),
    .A2(PENABLE),
    .A3(PWRITE),
    .A4(_168_),
    .ZN(_285_)
  );
  MUX2_X1 _674_ (
    .A(spi_dummy_wr[14]),
    .B(PWDATA[30]),
    .S(_285_),
    .Z(_067_)
  );
  MUX2_X1 _675_ (
    .A(spi_dummy_wr[13]),
    .B(PWDATA[29]),
    .S(_285_),
    .Z(_068_)
  );
  MUX2_X1 _676_ (
    .A(spi_dummy_wr[12]),
    .B(PWDATA[28]),
    .S(_285_),
    .Z(_069_)
  );
  MUX2_X1 _677_ (
    .A(spi_dummy_wr[11]),
    .B(PWDATA[27]),
    .S(_285_),
    .Z(_070_)
  );
  MUX2_X1 _678_ (
    .A(spi_dummy_wr[10]),
    .B(PWDATA[26]),
    .S(_285_),
    .Z(_071_)
  );
  MUX2_X1 _679_ (
    .A(spi_dummy_wr[9]),
    .B(PWDATA[25]),
    .S(_285_),
    .Z(_072_)
  );
  MUX2_X1 _680_ (
    .A(spi_dummy_wr[8]),
    .B(PWDATA[24]),
    .S(_285_),
    .Z(_073_)
  );
  MUX2_X1 _681_ (
    .A(spi_dummy_wr[7]),
    .B(PWDATA[23]),
    .S(_285_),
    .Z(_074_)
  );
  MUX2_X1 _682_ (
    .A(spi_dummy_wr[6]),
    .B(PWDATA[22]),
    .S(_285_),
    .Z(_075_)
  );
  MUX2_X1 _683_ (
    .A(spi_dummy_wr[5]),
    .B(PWDATA[21]),
    .S(_285_),
    .Z(_076_)
  );
  MUX2_X1 _684_ (
    .A(spi_dummy_wr[4]),
    .B(PWDATA[20]),
    .S(_285_),
    .Z(_077_)
  );
  MUX2_X1 _685_ (
    .A(spi_dummy_wr[3]),
    .B(PWDATA[19]),
    .S(_285_),
    .Z(_078_)
  );
  MUX2_X1 _686_ (
    .A(spi_dummy_wr[2]),
    .B(PWDATA[18]),
    .S(_285_),
    .Z(_079_)
  );
  MUX2_X1 _687_ (
    .A(spi_dummy_wr[1]),
    .B(PWDATA[17]),
    .S(_285_),
    .Z(_080_)
  );
  MUX2_X1 _688_ (
    .A(spi_dummy_wr[0]),
    .B(PWDATA[16]),
    .S(_285_),
    .Z(_081_)
  );
  MUX2_X1 _689_ (
    .A(spi_int_th_rx[3]),
    .B(PWDATA[11]),
    .S(_283_),
    .Z(_082_)
  );
  MUX2_X1 _690_ (
    .A(spi_int_th_rx[2]),
    .B(PWDATA[10]),
    .S(_283_),
    .Z(_083_)
  );
  MUX2_X1 _691_ (
    .A(spi_int_th_rx[1]),
    .B(PWDATA[9]),
    .S(_283_),
    .Z(_084_)
  );
  MUX2_X1 _692_ (
    .A(spi_int_th_rx[0]),
    .B(PWDATA[8]),
    .S(_283_),
    .Z(_085_)
  );
  MUX2_X1 _693_ (
    .A(PWDATA[4]),
    .B(spi_cmd_len[4]),
    .S(_282_),
    .Z(_086_)
  );
  MUX2_X1 _694_ (
    .A(PWDATA[3]),
    .B(spi_cmd_len[3]),
    .S(_282_),
    .Z(_087_)
  );
  MUX2_X1 _695_ (
    .A(PWDATA[2]),
    .B(spi_cmd_len[2]),
    .S(_282_),
    .Z(_088_)
  );
  MUX2_X1 _696_ (
    .A(PWDATA[1]),
    .B(spi_cmd_len[1]),
    .S(_282_),
    .Z(_089_)
  );
  MUX2_X1 _697_ (
    .A(PWDATA[0]),
    .B(spi_cmd_len[0]),
    .S(_282_),
    .Z(_090_)
  );
  MUX2_X1 _698_ (
    .A(spi_int_cnt_rx[3]),
    .B(PWDATA[27]),
    .S(_283_),
    .Z(_091_)
  );
  MUX2_X1 _699_ (
    .A(spi_int_cnt_rx[2]),
    .B(PWDATA[26]),
    .S(_283_),
    .Z(_092_)
  );
  MUX2_X1 _700_ (
    .A(spi_int_cnt_rx[1]),
    .B(PWDATA[25]),
    .S(_283_),
    .Z(_093_)
  );
  MUX2_X1 _701_ (
    .A(spi_int_cnt_rx[0]),
    .B(PWDATA[24]),
    .S(_283_),
    .Z(_094_)
  );
  MUX2_X1 _702_ (
    .A(spi_clk_div[6]),
    .B(PWDATA[6]),
    .S(_000_),
    .Z(_095_)
  );
  MUX2_X1 _703_ (
    .A(spi_clk_div[5]),
    .B(PWDATA[5]),
    .S(_000_),
    .Z(_096_)
  );
  MUX2_X1 _704_ (
    .A(spi_clk_div[4]),
    .B(PWDATA[4]),
    .S(_000_),
    .Z(_097_)
  );
  MUX2_X1 _705_ (
    .A(spi_clk_div[3]),
    .B(PWDATA[3]),
    .S(_000_),
    .Z(_098_)
  );
  MUX2_X1 _706_ (
    .A(spi_clk_div[2]),
    .B(PWDATA[2]),
    .S(_000_),
    .Z(_099_)
  );
  MUX2_X1 _707_ (
    .A(spi_clk_div[1]),
    .B(PWDATA[1]),
    .S(_000_),
    .Z(_100_)
  );
  MUX2_X1 _708_ (
    .A(spi_clk_div[0]),
    .B(PWDATA[0]),
    .S(_000_),
    .Z(_101_)
  );
  MUX2_X1 _709_ (
    .A(PWDATA[5]),
    .B(spi_cmd_len[5]),
    .S(_282_),
    .Z(_102_)
  );
  MUX2_X1 _710_ (
    .A(spi_int_cnt_tx[3]),
    .B(PWDATA[19]),
    .S(_283_),
    .Z(_103_)
  );
  MUX2_X1 _711_ (
    .A(spi_int_cnt_tx[2]),
    .B(PWDATA[18]),
    .S(_283_),
    .Z(_104_)
  );
  MUX2_X1 _712_ (
    .A(spi_int_cnt_tx[1]),
    .B(PWDATA[17]),
    .S(_283_),
    .Z(_105_)
  );
  MUX2_X1 _713_ (
    .A(spi_int_cnt_tx[0]),
    .B(PWDATA[16]),
    .S(_283_),
    .Z(_106_)
  );
  MUX2_X1 _714_ (
    .A(PWDATA[30]),
    .B(spi_data_len[14]),
    .S(_282_),
    .Z(_107_)
  );
  MUX2_X1 _715_ (
    .A(PWDATA[29]),
    .B(spi_data_len[13]),
    .S(_282_),
    .Z(_108_)
  );
  MUX2_X1 _716_ (
    .A(spi_clk_div[7]),
    .B(PWDATA[7]),
    .S(_000_),
    .Z(_109_)
  );
  MUX2_X1 _717_ (
    .A(PWDATA[28]),
    .B(spi_data_len[12]),
    .S(_282_),
    .Z(_110_)
  );
  MUX2_X1 _718_ (
    .A(PWDATA[27]),
    .B(spi_data_len[11]),
    .S(_282_),
    .Z(_111_)
  );
  MUX2_X1 _719_ (
    .A(spi_int_cnt_en),
    .B(PWDATA[30]),
    .S(_283_),
    .Z(_112_)
  );
  MUX2_X1 _720_ (
    .A(PWDATA[26]),
    .B(spi_data_len[10]),
    .S(_282_),
    .Z(_113_)
  );
  MUX2_X1 _721_ (
    .A(spi_int_th_rx[4]),
    .B(PWDATA[12]),
    .S(_283_),
    .Z(_114_)
  );
  MUX2_X1 _722_ (
    .A(PWDATA[25]),
    .B(spi_data_len[9]),
    .S(_282_),
    .Z(_115_)
  );
  MUX2_X1 _723_ (
    .A(PWDATA[24]),
    .B(spi_data_len[8]),
    .S(_282_),
    .Z(_116_)
  );
  MUX2_X1 _724_ (
    .A(spi_dummy_wr[15]),
    .B(PWDATA[31]),
    .S(_285_),
    .Z(_117_)
  );
  MUX2_X1 _725_ (
    .A(PWDATA[23]),
    .B(spi_data_len[7]),
    .S(_282_),
    .Z(_118_)
  );
  MUX2_X1 _726_ (
    .A(PWDATA[22]),
    .B(spi_data_len[6]),
    .S(_282_),
    .Z(_119_)
  );
  MUX2_X1 _727_ (
    .A(PWDATA[21]),
    .B(spi_data_len[5]),
    .S(_282_),
    .Z(_120_)
  );
  MUX2_X1 _728_ (
    .A(spi_cmd[31]),
    .B(PWDATA[31]),
    .S(_284_),
    .Z(_121_)
  );
  MUX2_X1 _729_ (
    .A(PWDATA[20]),
    .B(spi_data_len[4]),
    .S(_282_),
    .Z(_122_)
  );
  MUX2_X1 _730_ (
    .A(PWDATA[19]),
    .B(spi_data_len[3]),
    .S(_282_),
    .Z(_123_)
  );
  MUX2_X1 _731_ (
    .A(PWDATA[18]),
    .B(spi_data_len[2]),
    .S(_282_),
    .Z(_124_)
  );
  MUX2_X1 _732_ (
    .A(PWDATA[17]),
    .B(spi_data_len[1]),
    .S(_282_),
    .Z(_125_)
  );
  MUX2_X1 _733_ (
    .A(spi_int_cnt_rx[4]),
    .B(PWDATA[28]),
    .S(_283_),
    .Z(_126_)
  );
  MUX2_X1 _734_ (
    .A(spi_int_th_tx[4]),
    .B(PWDATA[4]),
    .S(_283_),
    .Z(_127_)
  );
  MUX2_X1 _735_ (
    .A(PWDATA[16]),
    .B(spi_data_len[0]),
    .S(_282_),
    .Z(_128_)
  );
  MUX2_X1 _736_ (
    .A(spi_dummy_rd[14]),
    .B(PWDATA[14]),
    .S(_285_),
    .Z(_129_)
  );
  MUX2_X1 _737_ (
    .A(PWDATA[13]),
    .B(spi_addr_len[5]),
    .S(_282_),
    .Z(_130_)
  );
  MUX2_X1 _738_ (
    .A(spi_dummy_rd[13]),
    .B(PWDATA[13]),
    .S(_285_),
    .Z(_131_)
  );
  MUX2_X1 _739_ (
    .A(spi_dummy_rd[12]),
    .B(PWDATA[12]),
    .S(_285_),
    .Z(_132_)
  );
  MUX2_X1 _740_ (
    .A(spi_dummy_rd[11]),
    .B(PWDATA[11]),
    .S(_285_),
    .Z(_133_)
  );
  MUX2_X1 _741_ (
    .A(spi_dummy_rd[10]),
    .B(PWDATA[10]),
    .S(_285_),
    .Z(_134_)
  );
  MUX2_X1 _742_ (
    .A(spi_dummy_rd[9]),
    .B(PWDATA[9]),
    .S(_285_),
    .Z(_135_)
  );
  MUX2_X1 _743_ (
    .A(spi_dummy_rd[8]),
    .B(PWDATA[8]),
    .S(_285_),
    .Z(_136_)
  );
  MUX2_X1 _744_ (
    .A(spi_dummy_rd[7]),
    .B(PWDATA[7]),
    .S(_285_),
    .Z(_137_)
  );
  MUX2_X1 _745_ (
    .A(spi_dummy_rd[6]),
    .B(PWDATA[6]),
    .S(_285_),
    .Z(_138_)
  );
  MUX2_X1 _746_ (
    .A(spi_addr[31]),
    .B(PWDATA[31]),
    .S(_281_),
    .Z(_139_)
  );
  MUX2_X1 _747_ (
    .A(spi_dummy_rd[5]),
    .B(PWDATA[5]),
    .S(_285_),
    .Z(_140_)
  );
  MUX2_X1 _748_ (
    .A(spi_dummy_rd[4]),
    .B(PWDATA[4]),
    .S(_285_),
    .Z(_141_)
  );
  MUX2_X1 _749_ (
    .A(spi_csreg[3]),
    .B(PWDATA[11]),
    .S(_279_),
    .Z(_142_)
  );
  MUX2_X1 _750_ (
    .A(spi_dummy_rd[3]),
    .B(PWDATA[3]),
    .S(_285_),
    .Z(_143_)
  );
  MUX2_X1 _751_ (
    .A(spi_dummy_rd[2]),
    .B(PWDATA[2]),
    .S(_285_),
    .Z(_144_)
  );
  MUX2_X1 _752_ (
    .A(spi_dummy_rd[15]),
    .B(PWDATA[15]),
    .S(_285_),
    .Z(_145_)
  );
  MUX2_X1 _753_ (
    .A(spi_dummy_rd[1]),
    .B(PWDATA[1]),
    .S(_285_),
    .Z(_146_)
  );
  MUX2_X1 _754_ (
    .A(spi_dummy_rd[0]),
    .B(PWDATA[0]),
    .S(_285_),
    .Z(_147_)
  );
  MUX2_X1 _755_ (
    .A(spi_csreg[2]),
    .B(PWDATA[10]),
    .S(_279_),
    .Z(_148_)
  );
  MUX2_X1 _756_ (
    .A(spi_csreg[1]),
    .B(PWDATA[9]),
    .S(_279_),
    .Z(_149_)
  );
  MUX2_X1 _757_ (
    .A(spi_csreg[0]),
    .B(PWDATA[8]),
    .S(_279_),
    .Z(_150_)
  );
  MUX2_X1 _758_ (
    .A(spi_addr[30]),
    .B(PWDATA[30]),
    .S(_281_),
    .Z(_151_)
  );
  MUX2_X1 _759_ (
    .A(spi_addr[29]),
    .B(PWDATA[29]),
    .S(_281_),
    .Z(_152_)
  );
  MUX2_X1 _760_ (
    .A(spi_addr[28]),
    .B(PWDATA[28]),
    .S(_281_),
    .Z(_153_)
  );
  MUX2_X1 _761_ (
    .A(spi_addr[27]),
    .B(PWDATA[27]),
    .S(_281_),
    .Z(_154_)
  );
  MUX2_X1 _762_ (
    .A(spi_addr[26]),
    .B(PWDATA[26]),
    .S(_281_),
    .Z(_155_)
  );
  MUX2_X1 _763_ (
    .A(spi_addr[25]),
    .B(PWDATA[25]),
    .S(_281_),
    .Z(_156_)
  );
  MUX2_X1 _764_ (
    .A(spi_addr[24]),
    .B(PWDATA[24]),
    .S(_281_),
    .Z(_157_)
  );
  MUX2_X1 _765_ (
    .A(PWDATA[31]),
    .B(spi_data_len[15]),
    .S(_282_),
    .Z(_158_)
  );
  MUX2_X1 _766_ (
    .A(spi_addr[23]),
    .B(PWDATA[23]),
    .S(_281_),
    .Z(_159_)
  );
  MUX2_X1 _767_ (
    .A(spi_addr[22]),
    .B(PWDATA[22]),
    .S(_281_),
    .Z(_160_)
  );
  MUX2_X1 _768_ (
    .A(spi_int_cnt_tx[4]),
    .B(PWDATA[20]),
    .S(_283_),
    .Z(_161_)
  );
  MUX2_X1 _769_ (
    .A(spi_int_en),
    .B(PWDATA[31]),
    .S(_283_),
    .Z(_162_)
  );
  MUX2_X1 _770_ (
    .A(spi_addr[21]),
    .B(PWDATA[21]),
    .S(_281_),
    .Z(_163_)
  );
  DFFR_X1 _771_ (
    .CK(HCLK),
    .D(_112_),
    .Q(spi_int_cnt_en),
    .QN(_337_),
    .RN(HRESETn)
  );
  DFFR_X1 _772_ (
    .CK(HCLK),
    .D(_101_),
    .Q(spi_clk_div[0]),
    .QN(_348_),
    .RN(HRESETn)
  );
  DFFR_X1 _773_ (
    .CK(HCLK),
    .D(_100_),
    .Q(spi_clk_div[1]),
    .QN(_349_),
    .RN(HRESETn)
  );
  DFFR_X1 _774_ (
    .CK(HCLK),
    .D(_099_),
    .Q(spi_clk_div[2]),
    .QN(_350_),
    .RN(HRESETn)
  );
  DFFR_X1 _775_ (
    .CK(HCLK),
    .D(_098_),
    .Q(spi_clk_div[3]),
    .QN(_351_),
    .RN(HRESETn)
  );
  DFFR_X1 _776_ (
    .CK(HCLK),
    .D(_097_),
    .Q(spi_clk_div[4]),
    .QN(_352_),
    .RN(HRESETn)
  );
  DFFR_X1 _777_ (
    .CK(HCLK),
    .D(_096_),
    .Q(spi_clk_div[5]),
    .QN(_353_),
    .RN(HRESETn)
  );
  DFFR_X1 _778_ (
    .CK(HCLK),
    .D(_095_),
    .Q(spi_clk_div[6]),
    .QN(_354_),
    .RN(HRESETn)
  );
  DFFR_X1 _779_ (
    .CK(HCLK),
    .D(_109_),
    .Q(spi_clk_div[7]),
    .QN(_340_),
    .RN(HRESETn)
  );
  DFFR_X1 _780_ (
    .CK(HCLK),
    .D(_094_),
    .Q(spi_int_cnt_rx[0]),
    .QN(_355_),
    .RN(HRESETn)
  );
  DFFR_X1 _781_ (
    .CK(HCLK),
    .D(_093_),
    .Q(spi_int_cnt_rx[1]),
    .QN(_356_),
    .RN(HRESETn)
  );
  DFFR_X1 _782_ (
    .CK(HCLK),
    .D(_092_),
    .Q(spi_int_cnt_rx[2]),
    .QN(_357_),
    .RN(HRESETn)
  );
  DFFR_X1 _783_ (
    .CK(HCLK),
    .D(_091_),
    .Q(spi_int_cnt_rx[3]),
    .QN(_358_),
    .RN(HRESETn)
  );
  DFFR_X1 _784_ (
    .CK(HCLK),
    .D(_126_),
    .Q(spi_int_cnt_rx[4]),
    .QN(_323_),
    .RN(HRESETn)
  );
  DFFR_X1 _785_ (
    .CK(HCLK),
    .D(_162_),
    .Q(spi_int_en),
    .QN(_287_),
    .RN(HRESETn)
  );
  DFFR_X1 _786_ (
    .CK(HCLK),
    .D(_090_),
    .Q(spi_cmd_len[0]),
    .QN(_359_),
    .RN(HRESETn)
  );
  DFFR_X1 _787_ (
    .CK(HCLK),
    .D(_089_),
    .Q(spi_cmd_len[1]),
    .QN(_360_),
    .RN(HRESETn)
  );
  DFFR_X1 _788_ (
    .CK(HCLK),
    .D(_088_),
    .Q(spi_cmd_len[2]),
    .QN(_361_),
    .RN(HRESETn)
  );
  DFFR_X1 _789_ (
    .CK(HCLK),
    .D(_087_),
    .Q(spi_cmd_len[3]),
    .QN(_362_),
    .RN(HRESETn)
  );
  DFFR_X1 _790_ (
    .CK(HCLK),
    .D(_086_),
    .Q(spi_cmd_len[4]),
    .QN(_363_),
    .RN(HRESETn)
  );
  DFFR_X1 _791_ (
    .CK(HCLK),
    .D(_102_),
    .Q(spi_cmd_len[5]),
    .QN(_347_),
    .RN(HRESETn)
  );
  DFFR_X1 _792_ (
    .CK(HCLK),
    .D(_085_),
    .Q(spi_int_th_rx[0]),
    .QN(_364_),
    .RN(HRESETn)
  );
  DFFR_X1 _793_ (
    .CK(HCLK),
    .D(_084_),
    .Q(spi_int_th_rx[1]),
    .QN(_365_),
    .RN(HRESETn)
  );
  DFFR_X1 _794_ (
    .CK(HCLK),
    .D(_083_),
    .Q(spi_int_th_rx[2]),
    .QN(_366_),
    .RN(HRESETn)
  );
  DFFR_X1 _795_ (
    .CK(HCLK),
    .D(_082_),
    .Q(spi_int_th_rx[3]),
    .QN(_367_),
    .RN(HRESETn)
  );
  DFFR_X1 _796_ (
    .CK(HCLK),
    .D(_114_),
    .Q(spi_int_th_rx[4]),
    .QN(_335_),
    .RN(HRESETn)
  );
  DFFR_X1 _797_ (
    .CK(HCLK),
    .D(_081_),
    .Q(spi_dummy_wr[0]),
    .QN(_368_),
    .RN(HRESETn)
  );
  DFFR_X1 _798_ (
    .CK(HCLK),
    .D(_080_),
    .Q(spi_dummy_wr[1]),
    .QN(_369_),
    .RN(HRESETn)
  );
  DFFR_X1 _799_ (
    .CK(HCLK),
    .D(_079_),
    .Q(spi_dummy_wr[2]),
    .QN(_370_),
    .RN(HRESETn)
  );
  DFFR_X1 _800_ (
    .CK(HCLK),
    .D(_078_),
    .Q(spi_dummy_wr[3]),
    .QN(_371_),
    .RN(HRESETn)
  );
  DFFR_X1 _801_ (
    .CK(HCLK),
    .D(_077_),
    .Q(spi_dummy_wr[4]),
    .QN(_372_),
    .RN(HRESETn)
  );
  DFFR_X1 _802_ (
    .CK(HCLK),
    .D(_076_),
    .Q(spi_dummy_wr[5]),
    .QN(_373_),
    .RN(HRESETn)
  );
  DFFR_X1 _803_ (
    .CK(HCLK),
    .D(_075_),
    .Q(spi_dummy_wr[6]),
    .QN(_374_),
    .RN(HRESETn)
  );
  DFFR_X1 _804_ (
    .CK(HCLK),
    .D(_074_),
    .Q(spi_dummy_wr[7]),
    .QN(_375_),
    .RN(HRESETn)
  );
  DFFR_X1 _805_ (
    .CK(HCLK),
    .D(_073_),
    .Q(spi_dummy_wr[8]),
    .QN(_376_),
    .RN(HRESETn)
  );
  DFFR_X1 _806_ (
    .CK(HCLK),
    .D(_072_),
    .Q(spi_dummy_wr[9]),
    .QN(_377_),
    .RN(HRESETn)
  );
  DFFR_X1 _807_ (
    .CK(HCLK),
    .D(_071_),
    .Q(spi_dummy_wr[10]),
    .QN(_378_),
    .RN(HRESETn)
  );
  DFFR_X1 _808_ (
    .CK(HCLK),
    .D(_070_),
    .Q(spi_dummy_wr[11]),
    .QN(_379_),
    .RN(HRESETn)
  );
  DFFR_X1 _809_ (
    .CK(HCLK),
    .D(_069_),
    .Q(spi_dummy_wr[12]),
    .QN(_380_),
    .RN(HRESETn)
  );
  DFFR_X1 _810_ (
    .CK(HCLK),
    .D(_068_),
    .Q(spi_dummy_wr[13]),
    .QN(_381_),
    .RN(HRESETn)
  );
  DFFR_X1 _811_ (
    .CK(HCLK),
    .D(_067_),
    .Q(spi_dummy_wr[14]),
    .QN(_382_),
    .RN(HRESETn)
  );
  DFFR_X1 _812_ (
    .CK(HCLK),
    .D(_117_),
    .Q(spi_dummy_wr[15]),
    .QN(_332_),
    .RN(HRESETn)
  );
  DFFR_X1 _813_ (
    .CK(HCLK),
    .D(_066_),
    .Q(spi_cmd[0]),
    .QN(_383_),
    .RN(HRESETn)
  );
  DFFR_X1 _814_ (
    .CK(HCLK),
    .D(_065_),
    .Q(spi_cmd[1]),
    .QN(_384_),
    .RN(HRESETn)
  );
  DFFR_X1 _815_ (
    .CK(HCLK),
    .D(_064_),
    .Q(spi_cmd[2]),
    .QN(_385_),
    .RN(HRESETn)
  );
  DFFR_X1 _816_ (
    .CK(HCLK),
    .D(_063_),
    .Q(spi_cmd[3]),
    .QN(_386_),
    .RN(HRESETn)
  );
  DFFR_X1 _817_ (
    .CK(HCLK),
    .D(_062_),
    .Q(spi_cmd[4]),
    .QN(_387_),
    .RN(HRESETn)
  );
  DFFR_X1 _818_ (
    .CK(HCLK),
    .D(_061_),
    .Q(spi_cmd[5]),
    .QN(_388_),
    .RN(HRESETn)
  );
  DFFR_X1 _819_ (
    .CK(HCLK),
    .D(_060_),
    .Q(spi_cmd[6]),
    .QN(_389_),
    .RN(HRESETn)
  );
  DFFR_X1 _820_ (
    .CK(HCLK),
    .D(_059_),
    .Q(spi_cmd[7]),
    .QN(_390_),
    .RN(HRESETn)
  );
  DFFR_X1 _821_ (
    .CK(HCLK),
    .D(_058_),
    .Q(spi_cmd[8]),
    .QN(_391_),
    .RN(HRESETn)
  );
  DFFR_X1 _822_ (
    .CK(HCLK),
    .D(_057_),
    .Q(spi_cmd[9]),
    .QN(_392_),
    .RN(HRESETn)
  );
  DFFR_X1 _823_ (
    .CK(HCLK),
    .D(_056_),
    .Q(spi_cmd[10]),
    .QN(_393_),
    .RN(HRESETn)
  );
  DFFR_X1 _824_ (
    .CK(HCLK),
    .D(_055_),
    .Q(spi_cmd[11]),
    .QN(_394_),
    .RN(HRESETn)
  );
  DFFR_X1 _825_ (
    .CK(HCLK),
    .D(_054_),
    .Q(spi_cmd[12]),
    .QN(_395_),
    .RN(HRESETn)
  );
  DFFR_X1 _826_ (
    .CK(HCLK),
    .D(_053_),
    .Q(spi_cmd[13]),
    .QN(_396_),
    .RN(HRESETn)
  );
  DFFR_X1 _827_ (
    .CK(HCLK),
    .D(_052_),
    .Q(spi_cmd[14]),
    .QN(_397_),
    .RN(HRESETn)
  );
  DFFR_X1 _828_ (
    .CK(HCLK),
    .D(_051_),
    .Q(spi_cmd[15]),
    .QN(_398_),
    .RN(HRESETn)
  );
  DFFR_X1 _829_ (
    .CK(HCLK),
    .D(_050_),
    .Q(spi_cmd[16]),
    .QN(_399_),
    .RN(HRESETn)
  );
  DFFR_X1 _830_ (
    .CK(HCLK),
    .D(_049_),
    .Q(spi_cmd[17]),
    .QN(_400_),
    .RN(HRESETn)
  );
  DFFR_X1 _831_ (
    .CK(HCLK),
    .D(_048_),
    .Q(spi_cmd[18]),
    .QN(_401_),
    .RN(HRESETn)
  );
  DFFR_X1 _832_ (
    .CK(HCLK),
    .D(_047_),
    .Q(spi_cmd[19]),
    .QN(_402_),
    .RN(HRESETn)
  );
  DFFR_X1 _833_ (
    .CK(HCLK),
    .D(_046_),
    .Q(spi_cmd[20]),
    .QN(_403_),
    .RN(HRESETn)
  );
  DFFR_X1 _834_ (
    .CK(HCLK),
    .D(_045_),
    .Q(spi_cmd[21]),
    .QN(_404_),
    .RN(HRESETn)
  );
  DFFR_X1 _835_ (
    .CK(HCLK),
    .D(_044_),
    .Q(spi_cmd[22]),
    .QN(_405_),
    .RN(HRESETn)
  );
  DFFR_X1 _836_ (
    .CK(HCLK),
    .D(_043_),
    .Q(spi_cmd[23]),
    .QN(_406_),
    .RN(HRESETn)
  );
  DFFR_X1 _837_ (
    .CK(HCLK),
    .D(_042_),
    .Q(spi_cmd[24]),
    .QN(_407_),
    .RN(HRESETn)
  );
  DFFR_X1 _838_ (
    .CK(HCLK),
    .D(_041_),
    .Q(spi_cmd[25]),
    .QN(_408_),
    .RN(HRESETn)
  );
  DFFR_X1 _839_ (
    .CK(HCLK),
    .D(_040_),
    .Q(spi_cmd[26]),
    .QN(_409_),
    .RN(HRESETn)
  );
  DFFR_X1 _840_ (
    .CK(HCLK),
    .D(_039_),
    .Q(spi_cmd[27]),
    .QN(_410_),
    .RN(HRESETn)
  );
  DFFR_X1 _841_ (
    .CK(HCLK),
    .D(_038_),
    .Q(spi_cmd[28]),
    .QN(_411_),
    .RN(HRESETn)
  );
  DFFR_X1 _842_ (
    .CK(HCLK),
    .D(_037_),
    .Q(spi_cmd[29]),
    .QN(_412_),
    .RN(HRESETn)
  );
  DFFR_X1 _843_ (
    .CK(HCLK),
    .D(_036_),
    .Q(spi_cmd[30]),
    .QN(_413_),
    .RN(HRESETn)
  );
  DFFR_X1 _844_ (
    .CK(HCLK),
    .D(_121_),
    .Q(spi_cmd[31]),
    .QN(_328_),
    .RN(HRESETn)
  );
  DFFR_X1 _845_ (
    .CK(HCLK),
    .D(_035_),
    .Q(spi_int_th_tx[0]),
    .QN(_414_),
    .RN(HRESETn)
  );
  DFFR_X1 _846_ (
    .CK(HCLK),
    .D(_034_),
    .Q(spi_int_th_tx[1]),
    .QN(_415_),
    .RN(HRESETn)
  );
  DFFR_X1 _847_ (
    .CK(HCLK),
    .D(_033_),
    .Q(spi_int_th_tx[2]),
    .QN(_416_),
    .RN(HRESETn)
  );
  DFFR_X1 _848_ (
    .CK(HCLK),
    .D(_032_),
    .Q(spi_int_th_tx[3]),
    .QN(_417_),
    .RN(HRESETn)
  );
  DFFR_X1 _849_ (
    .CK(HCLK),
    .D(_127_),
    .Q(spi_int_th_tx[4]),
    .QN(_322_),
    .RN(HRESETn)
  );
  DFFR_X1 _850_ (
    .CK(HCLK),
    .D(_031_),
    .Q(spi_addr_len[0]),
    .QN(_418_),
    .RN(HRESETn)
  );
  DFFR_X1 _851_ (
    .CK(HCLK),
    .D(_030_),
    .Q(spi_addr_len[1]),
    .QN(_419_),
    .RN(HRESETn)
  );
  DFFR_X1 _852_ (
    .CK(HCLK),
    .D(_029_),
    .Q(spi_addr_len[2]),
    .QN(_420_),
    .RN(HRESETn)
  );
  DFFR_X1 _853_ (
    .CK(HCLK),
    .D(_028_),
    .Q(spi_addr_len[3]),
    .QN(_421_),
    .RN(HRESETn)
  );
  DFFR_X1 _854_ (
    .CK(HCLK),
    .D(_027_),
    .Q(spi_addr_len[4]),
    .QN(_422_),
    .RN(HRESETn)
  );
  DFFR_X1 _855_ (
    .CK(HCLK),
    .D(_130_),
    .Q(spi_addr_len[5]),
    .QN(_319_),
    .RN(HRESETn)
  );
  DFFR_X1 _856_ (
    .CK(HCLK),
    .D(_026_),
    .Q(spi_addr[0]),
    .QN(_423_),
    .RN(HRESETn)
  );
  DFFR_X1 _857_ (
    .CK(HCLK),
    .D(_025_),
    .Q(spi_addr[1]),
    .QN(_424_),
    .RN(HRESETn)
  );
  DFFR_X1 _858_ (
    .CK(HCLK),
    .D(_024_),
    .Q(spi_addr[2]),
    .QN(_425_),
    .RN(HRESETn)
  );
  DFFR_X1 _859_ (
    .CK(HCLK),
    .D(_023_),
    .Q(spi_addr[3]),
    .QN(_426_),
    .RN(HRESETn)
  );
  DFFR_X1 _860_ (
    .CK(HCLK),
    .D(_022_),
    .Q(spi_addr[4]),
    .QN(_427_),
    .RN(HRESETn)
  );
  DFFR_X1 _861_ (
    .CK(HCLK),
    .D(_021_),
    .Q(spi_addr[5]),
    .QN(_428_),
    .RN(HRESETn)
  );
  DFFR_X1 _862_ (
    .CK(HCLK),
    .D(_020_),
    .Q(spi_addr[6]),
    .QN(_429_),
    .RN(HRESETn)
  );
  DFFR_X1 _863_ (
    .CK(HCLK),
    .D(_019_),
    .Q(spi_addr[7]),
    .QN(_430_),
    .RN(HRESETn)
  );
  DFFR_X1 _864_ (
    .CK(HCLK),
    .D(_018_),
    .Q(spi_addr[8]),
    .QN(_431_),
    .RN(HRESETn)
  );
  DFFR_X1 _865_ (
    .CK(HCLK),
    .D(_017_),
    .Q(spi_addr[9]),
    .QN(_432_),
    .RN(HRESETn)
  );
  DFFR_X1 _866_ (
    .CK(HCLK),
    .D(_016_),
    .Q(spi_addr[10]),
    .QN(_433_),
    .RN(HRESETn)
  );
  DFFR_X1 _867_ (
    .CK(HCLK),
    .D(_015_),
    .Q(spi_addr[11]),
    .QN(_434_),
    .RN(HRESETn)
  );
  DFFR_X1 _868_ (
    .CK(HCLK),
    .D(_014_),
    .Q(spi_addr[12]),
    .QN(_435_),
    .RN(HRESETn)
  );
  DFFR_X1 _869_ (
    .CK(HCLK),
    .D(_013_),
    .Q(spi_addr[13]),
    .QN(_436_),
    .RN(HRESETn)
  );
  DFFR_X1 _870_ (
    .CK(HCLK),
    .D(_012_),
    .Q(spi_addr[14]),
    .QN(_437_),
    .RN(HRESETn)
  );
  DFFR_X1 _871_ (
    .CK(HCLK),
    .D(_011_),
    .Q(spi_addr[15]),
    .QN(_438_),
    .RN(HRESETn)
  );
  DFFR_X1 _872_ (
    .CK(HCLK),
    .D(_010_),
    .Q(spi_addr[16]),
    .QN(_439_),
    .RN(HRESETn)
  );
  DFFR_X1 _873_ (
    .CK(HCLK),
    .D(_009_),
    .Q(spi_addr[17]),
    .QN(_440_),
    .RN(HRESETn)
  );
  DFFR_X1 _874_ (
    .CK(HCLK),
    .D(_008_),
    .Q(spi_addr[18]),
    .QN(_441_),
    .RN(HRESETn)
  );
  DFFR_X1 _875_ (
    .CK(HCLK),
    .D(_007_),
    .Q(spi_addr[19]),
    .QN(_442_),
    .RN(HRESETn)
  );
  DFFR_X1 _876_ (
    .CK(HCLK),
    .D(_006_),
    .Q(spi_addr[20]),
    .QN(_443_),
    .RN(HRESETn)
  );
  DFFR_X1 _877_ (
    .CK(HCLK),
    .D(_163_),
    .Q(spi_addr[21]),
    .QN(_286_),
    .RN(HRESETn)
  );
  DFFR_X1 _878_ (
    .CK(HCLK),
    .D(_160_),
    .Q(spi_addr[22]),
    .QN(_289_),
    .RN(HRESETn)
  );
  DFFR_X1 _879_ (
    .CK(HCLK),
    .D(_159_),
    .Q(spi_addr[23]),
    .QN(_290_),
    .RN(HRESETn)
  );
  DFFR_X1 _880_ (
    .CK(HCLK),
    .D(_157_),
    .Q(spi_addr[24]),
    .QN(_292_),
    .RN(HRESETn)
  );
  DFFR_X1 _881_ (
    .CK(HCLK),
    .D(_156_),
    .Q(spi_addr[25]),
    .QN(_293_),
    .RN(HRESETn)
  );
  DFFR_X1 _882_ (
    .CK(HCLK),
    .D(_155_),
    .Q(spi_addr[26]),
    .QN(_449_),
    .RN(HRESETn)
  );
  DFFR_X1 _883_ (
    .CK(HCLK),
    .D(_154_),
    .Q(spi_addr[27]),
    .QN(_295_),
    .RN(HRESETn)
  );
  DFFR_X1 _884_ (
    .CK(HCLK),
    .D(_153_),
    .Q(spi_addr[28]),
    .QN(_296_),
    .RN(HRESETn)
  );
  DFFR_X1 _885_ (
    .CK(HCLK),
    .D(_152_),
    .Q(spi_addr[29]),
    .QN(_297_),
    .RN(HRESETn)
  );
  DFFR_X1 _886_ (
    .CK(HCLK),
    .D(_151_),
    .Q(spi_addr[30]),
    .QN(_298_),
    .RN(HRESETn)
  );
  DFFR_X1 _887_ (
    .CK(HCLK),
    .D(_139_),
    .Q(spi_addr[31]),
    .QN(_310_),
    .RN(HRESETn)
  );
  DFFR_X1 _888_ (
    .CK(HCLK),
    .D(_150_),
    .Q(spi_csreg[0]),
    .QN(_299_),
    .RN(HRESETn)
  );
  DFFR_X1 _889_ (
    .CK(HCLK),
    .D(_149_),
    .Q(spi_csreg[1]),
    .QN(_300_),
    .RN(HRESETn)
  );
  DFFR_X1 _890_ (
    .CK(HCLK),
    .D(_148_),
    .Q(spi_csreg[2]),
    .QN(_301_),
    .RN(HRESETn)
  );
  DFFR_X1 _891_ (
    .CK(HCLK),
    .D(_142_),
    .Q(spi_csreg[3]),
    .QN(_307_),
    .RN(HRESETn)
  );
  DFFR_X1 _892_ (
    .CK(HCLK),
    .D(_147_),
    .Q(spi_dummy_rd[0]),
    .QN(_302_),
    .RN(HRESETn)
  );
  DFFR_X1 _893_ (
    .CK(HCLK),
    .D(_146_),
    .Q(spi_dummy_rd[1]),
    .QN(_303_),
    .RN(HRESETn)
  );
  DFFR_X1 _894_ (
    .CK(HCLK),
    .D(_144_),
    .Q(spi_dummy_rd[2]),
    .QN(_305_),
    .RN(HRESETn)
  );
  DFFR_X1 _895_ (
    .CK(HCLK),
    .D(_143_),
    .Q(spi_dummy_rd[3]),
    .QN(_306_),
    .RN(HRESETn)
  );
  DFFR_X1 _896_ (
    .CK(HCLK),
    .D(_141_),
    .Q(spi_dummy_rd[4]),
    .QN(_308_),
    .RN(HRESETn)
  );
  DFFR_X1 _897_ (
    .CK(HCLK),
    .D(_140_),
    .Q(spi_dummy_rd[5]),
    .QN(_309_),
    .RN(HRESETn)
  );
  DFFR_X1 _898_ (
    .CK(HCLK),
    .D(_138_),
    .Q(spi_dummy_rd[6]),
    .QN(_311_),
    .RN(HRESETn)
  );
  DFFR_X1 _899_ (
    .CK(HCLK),
    .D(_137_),
    .Q(spi_dummy_rd[7]),
    .QN(_312_),
    .RN(HRESETn)
  );
  DFFR_X1 _900_ (
    .CK(HCLK),
    .D(_136_),
    .Q(spi_dummy_rd[8]),
    .QN(_313_),
    .RN(HRESETn)
  );
  DFFR_X1 _901_ (
    .CK(HCLK),
    .D(_135_),
    .Q(spi_dummy_rd[9]),
    .QN(_448_),
    .RN(HRESETn)
  );
  DFFR_X1 _902_ (
    .CK(HCLK),
    .D(_134_),
    .Q(spi_dummy_rd[10]),
    .QN(_315_),
    .RN(HRESETn)
  );
  DFFR_X1 _903_ (
    .CK(HCLK),
    .D(_133_),
    .Q(spi_dummy_rd[11]),
    .QN(_447_),
    .RN(HRESETn)
  );
  DFFR_X1 _904_ (
    .CK(HCLK),
    .D(_132_),
    .Q(spi_dummy_rd[12]),
    .QN(_317_),
    .RN(HRESETn)
  );
  DFFR_X1 _905_ (
    .CK(HCLK),
    .D(_131_),
    .Q(spi_dummy_rd[13]),
    .QN(_318_),
    .RN(HRESETn)
  );
  DFFR_X1 _906_ (
    .CK(HCLK),
    .D(_129_),
    .Q(spi_dummy_rd[14]),
    .QN(_320_),
    .RN(HRESETn)
  );
  DFFR_X1 _907_ (
    .CK(HCLK),
    .D(_145_),
    .Q(spi_dummy_rd[15]),
    .QN(_304_),
    .RN(HRESETn)
  );
  DFFR_X1 _908_ (
    .CK(HCLK),
    .D(_128_),
    .Q(spi_data_len[0]),
    .QN(_321_),
    .RN(HRESETn)
  );
  DFFR_X1 _909_ (
    .CK(HCLK),
    .D(_125_),
    .Q(spi_data_len[1]),
    .QN(_324_),
    .RN(HRESETn)
  );
  DFFR_X1 _910_ (
    .CK(HCLK),
    .D(_124_),
    .Q(spi_data_len[2]),
    .QN(_325_),
    .RN(HRESETn)
  );
  DFFR_X1 _911_ (
    .CK(HCLK),
    .D(_123_),
    .Q(spi_data_len[3]),
    .QN(_446_),
    .RN(HRESETn)
  );
  DFFR_X1 _912_ (
    .CK(HCLK),
    .D(_122_),
    .Q(spi_data_len[4]),
    .QN(_327_),
    .RN(HRESETn)
  );
  DFFR_X1 _913_ (
    .CK(HCLK),
    .D(_120_),
    .Q(spi_data_len[5]),
    .QN(_329_),
    .RN(HRESETn)
  );
  DFFR_X1 _914_ (
    .CK(HCLK),
    .D(_119_),
    .Q(spi_data_len[6]),
    .QN(_330_),
    .RN(HRESETn)
  );
  DFFR_X1 _915_ (
    .CK(HCLK),
    .D(_118_),
    .Q(spi_data_len[7]),
    .QN(_331_),
    .RN(HRESETn)
  );
  DFFR_X1 _916_ (
    .CK(HCLK),
    .D(_116_),
    .Q(spi_data_len[8]),
    .QN(_333_),
    .RN(HRESETn)
  );
  DFFR_X1 _917_ (
    .CK(HCLK),
    .D(_115_),
    .Q(spi_data_len[9]),
    .QN(_334_),
    .RN(HRESETn)
  );
  DFFR_X1 _918_ (
    .CK(HCLK),
    .D(_113_),
    .Q(spi_data_len[10]),
    .QN(_336_),
    .RN(HRESETn)
  );
  DFFR_X1 _919_ (
    .CK(HCLK),
    .D(_111_),
    .Q(spi_data_len[11]),
    .QN(_338_),
    .RN(HRESETn)
  );
  DFFR_X1 _920_ (
    .CK(HCLK),
    .D(_110_),
    .Q(spi_data_len[12]),
    .QN(_339_),
    .RN(HRESETn)
  );
  DFFR_X1 _921_ (
    .CK(HCLK),
    .D(_108_),
    .Q(spi_data_len[13]),
    .QN(_445_),
    .RN(HRESETn)
  );
  DFFR_X1 _922_ (
    .CK(HCLK),
    .D(_107_),
    .Q(spi_data_len[14]),
    .QN(_444_),
    .RN(HRESETn)
  );
  DFFR_X1 _923_ (
    .CK(HCLK),
    .D(_158_),
    .Q(spi_data_len[15]),
    .QN(_291_),
    .RN(HRESETn)
  );
  DFFR_X1 _924_ (
    .CK(HCLK),
    .D(_106_),
    .Q(spi_int_cnt_tx[0]),
    .QN(_343_),
    .RN(HRESETn)
  );
  DFFR_X1 _925_ (
    .CK(HCLK),
    .D(_105_),
    .Q(spi_int_cnt_tx[1]),
    .QN(_344_),
    .RN(HRESETn)
  );
  DFFR_X1 _926_ (
    .CK(HCLK),
    .D(_104_),
    .Q(spi_int_cnt_tx[2]),
    .QN(_345_),
    .RN(HRESETn)
  );
  DFFR_X1 _927_ (
    .CK(HCLK),
    .D(_103_),
    .Q(spi_int_cnt_tx[3]),
    .QN(_346_),
    .RN(HRESETn)
  );
  DFFR_X1 _928_ (
    .CK(HCLK),
    .D(_161_),
    .Q(spi_int_cnt_tx[4]),
    .QN(_288_),
    .RN(HRESETn)
  );
  DFFR_X1 _929_ (
    .CK(HCLK),
    .D(_000_),
    .Q(spi_clk_div_valid),
    .QN(_294_),
    .RN(HRESETn)
  );
  DFFR_X1 _930_ (
    .CK(HCLK),
    .D(_004_),
    .Q(spi_swrst),
    .QN(_314_),
    .RN(HRESETn)
  );
  DFFR_X1 _931_ (
    .CK(HCLK),
    .D(_003_),
    .Q(spi_rd),
    .QN(_316_),
    .RN(HRESETn)
  );
  DFFR_X1 _932_ (
    .CK(HCLK),
    .D(_005_),
    .Q(spi_wr),
    .QN(_341_),
    .RN(HRESETn)
  );
  DFFR_X1 _933_ (
    .CK(HCLK),
    .D(_001_),
    .Q(spi_qrd),
    .QN(_342_),
    .RN(HRESETn)
  );
  DFFR_X1 _934_ (
    .CK(HCLK),
    .D(_002_),
    .Q(spi_qwr),
    .QN(_326_),
    .RN(HRESETn)
  );
  assign read_address = PADDR[5:2];
  assign write_address = PADDR[5:2];
  assign spi_data_tx = PWDATA;
  assign PSLVERR = 1'h0;
  assign PREADY = 1'h1;
endmodule

module \$paramod$dec9424b776ed6cf19510f938baf4f9a5bd62edc\spi_master_fifo (clk_i, rst_ni, clr_i, elements_o, data_o, valid_o, ready_i, valid_i, data_i, ready_o);
  input clk_i;
  wire clk_i;
  input rst_ni;
  wire rst_ni;
  input clr_i;
  wire clr_i;
  output [4:0] elements_o;
  wire [4:0] elements_o;
  output [31:0] data_o;
  wire [31:0] data_o;
  output valid_o;
  wire valid_o;
  input ready_i;
  wire ready_i;
  input valid_i;
  wire valid_i;
  input [31:0] data_i;
  wire [31:0] data_i;
  output ready_o;
  wire ready_o;
  wire _0000_;
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
  wire [31:0] \buffer[0] ;
  wire [31:0] \buffer[1] ;
  wire [31:0] \buffer[2] ;
  wire [31:0] \buffer[3] ;
  wire [31:0] \buffer[4] ;
  wire [31:0] \buffer[5] ;
  wire [31:0] \buffer[6] ;
  wire [31:0] \buffer[7] ;
  wire [4:0] elements;
  wire [3:0] pointer_in;
  wire [3:0] pointer_out;
  INV_X1 _0725_ (
    .A(pointer_out[0]),
    .ZN(_0272_)
  );
  INV_X1 _0726_ (
    .A(pointer_out[1]),
    .ZN(_0273_)
  );
  INV_X1 _0727_ (
    .A(pointer_out[2]),
    .ZN(_0274_)
  );
  INV_X1 _0728_ (
    .A(elements[2]),
    .ZN(_0275_)
  );
  INV_X1 _0729_ (
    .A(elements[0]),
    .ZN(_0276_)
  );
  INV_X1 _0730_ (
    .A(elements[1]),
    .ZN(_0277_)
  );
  INV_X1 _0731_ (
    .A(elements[3]),
    .ZN(_0278_)
  );
  INV_X1 _0732_ (
    .A(ready_i),
    .ZN(_0279_)
  );
  INV_X1 _0733_ (
    .A(_0000_),
    .ZN(_0280_)
  );
  INV_X1 _0734_ (
    .A(valid_i),
    .ZN(_0281_)
  );
  INV_X1 _0735_ (
    .A(clr_i),
    .ZN(_0282_)
  );
  INV_X1 _0736_ (
    .A(pointer_in[1]),
    .ZN(_0283_)
  );
  INV_X1 _0737_ (
    .A(pointer_in[0]),
    .ZN(_0284_)
  );
  NAND2_X1 _0738_ (
    .A1(pointer_out[0]),
    .A2(pointer_out[1]),
    .ZN(_0285_)
  );
  NOR2_X1 _0739_ (
    .A1(pointer_out[2]),
    .A2(_0285_),
    .ZN(_0286_)
  );
  NOR3_X1 _0740_ (
    .A1(_0272_),
    .A2(pointer_out[1]),
    .A3(_0274_),
    .ZN(_0287_)
  );
  AOI22_X1 _0741_ (
    .A1(\buffer[3] [30]),
    .A2(_0286_),
    .B1(_0287_),
    .B2(\buffer[5] [30]),
    .ZN(_0288_)
  );
  NOR3_X1 _0742_ (
    .A1(pointer_out[0]),
    .A2(_0273_),
    .A3(_0274_),
    .ZN(_0289_)
  );
  NOR3_X1 _0743_ (
    .A1(pointer_out[0]),
    .A2(pointer_out[1]),
    .A3(_0274_),
    .ZN(_0290_)
  );
  AOI22_X1 _0744_ (
    .A1(\buffer[6] [30]),
    .A2(_0289_),
    .B1(_0290_),
    .B2(\buffer[4] [30]),
    .ZN(_0291_)
  );
  NOR2_X1 _0745_ (
    .A1(_0274_),
    .A2(_0285_),
    .ZN(_0292_)
  );
  NOR3_X1 _0746_ (
    .A1(pointer_out[0]),
    .A2(_0273_),
    .A3(pointer_out[2]),
    .ZN(_0293_)
  );
  AOI22_X1 _0747_ (
    .A1(\buffer[7] [30]),
    .A2(_0292_),
    .B1(_0293_),
    .B2(\buffer[2] [30]),
    .ZN(_0294_)
  );
  NOR3_X1 _0748_ (
    .A1(_0272_),
    .A2(pointer_out[1]),
    .A3(pointer_out[2]),
    .ZN(_0295_)
  );
  NOR3_X1 _0749_ (
    .A1(pointer_out[0]),
    .A2(pointer_out[1]),
    .A3(pointer_out[2]),
    .ZN(_0296_)
  );
  AOI22_X1 _0750_ (
    .A1(\buffer[1] [30]),
    .A2(_0295_),
    .B1(_0296_),
    .B2(\buffer[0] [30]),
    .ZN(_0297_)
  );
  NAND4_X1 _0751_ (
    .A1(_0288_),
    .A2(_0291_),
    .A3(_0294_),
    .A4(_0297_),
    .ZN(data_o[30])
  );
  AOI222_X1 _0752_ (
    .A1(\buffer[6] [29]),
    .A2(_0289_),
    .B1(_0295_),
    .B2(\buffer[1] [29]),
    .C1(_0290_),
    .C2(\buffer[4] [29]),
    .ZN(_0298_)
  );
  AOI222_X1 _0753_ (
    .A1(\buffer[3] [29]),
    .A2(_0286_),
    .B1(_0293_),
    .B2(\buffer[2] [29]),
    .C1(_0296_),
    .C2(\buffer[0] [29]),
    .ZN(_0299_)
  );
  AOI22_X1 _0754_ (
    .A1(\buffer[5] [29]),
    .A2(_0287_),
    .B1(_0292_),
    .B2(\buffer[7] [29]),
    .ZN(_0300_)
  );
  NAND3_X1 _0755_ (
    .A1(_0298_),
    .A2(_0299_),
    .A3(_0300_),
    .ZN(data_o[29])
  );
  AOI22_X1 _0756_ (
    .A1(\buffer[2] [28]),
    .A2(_0293_),
    .B1(_0296_),
    .B2(\buffer[0] [28]),
    .ZN(_0301_)
  );
  AOI222_X1 _0757_ (
    .A1(\buffer[3] [28]),
    .A2(_0286_),
    .B1(_0287_),
    .B2(\buffer[5] [28]),
    .C1(_0295_),
    .C2(\buffer[1] [28]),
    .ZN(_0302_)
  );
  AOI222_X1 _0758_ (
    .A1(\buffer[6] [28]),
    .A2(_0289_),
    .B1(_0292_),
    .B2(\buffer[7] [28]),
    .C1(_0290_),
    .C2(\buffer[4] [28]),
    .ZN(_0303_)
  );
  NAND3_X1 _0759_ (
    .A1(_0301_),
    .A2(_0302_),
    .A3(_0303_),
    .ZN(data_o[28])
  );
  AOI22_X1 _0760_ (
    .A1(\buffer[5] [27]),
    .A2(_0287_),
    .B1(_0296_),
    .B2(\buffer[0] [27]),
    .ZN(_0304_)
  );
  INV_X1 _0761_ (
    .A(_0304_),
    .ZN(_0305_)
  );
  AOI221_X1 _0762_ (
    .A(_0305_),
    .B1(_0293_),
    .B2(\buffer[2] [27]),
    .C1(\buffer[7] [27]),
    .C2(_0292_),
    .ZN(_0306_)
  );
  AOI22_X1 _0763_ (
    .A1(\buffer[3] [27]),
    .A2(_0286_),
    .B1(_0289_),
    .B2(\buffer[6] [27]),
    .ZN(_0307_)
  );
  AOI22_X1 _0764_ (
    .A1(\buffer[4] [27]),
    .A2(_0290_),
    .B1(_0295_),
    .B2(\buffer[1] [27]),
    .ZN(_0308_)
  );
  NAND3_X1 _0765_ (
    .A1(_0306_),
    .A2(_0307_),
    .A3(_0308_),
    .ZN(data_o[27])
  );
  AOI22_X1 _0766_ (
    .A1(\buffer[5] [26]),
    .A2(_0287_),
    .B1(_0290_),
    .B2(\buffer[4] [26]),
    .ZN(_0309_)
  );
  AOI222_X1 _0767_ (
    .A1(\buffer[3] [26]),
    .A2(_0286_),
    .B1(_0289_),
    .B2(\buffer[6] [26]),
    .C1(_0293_),
    .C2(\buffer[2] [26]),
    .ZN(_0310_)
  );
  AOI222_X1 _0768_ (
    .A1(\buffer[7] [26]),
    .A2(_0292_),
    .B1(_0295_),
    .B2(\buffer[1] [26]),
    .C1(_0296_),
    .C2(\buffer[0] [26]),
    .ZN(_0311_)
  );
  NAND3_X1 _0769_ (
    .A1(_0309_),
    .A2(_0310_),
    .A3(_0311_),
    .ZN(data_o[26])
  );
  AOI222_X1 _0770_ (
    .A1(\buffer[6] [25]),
    .A2(_0289_),
    .B1(_0292_),
    .B2(\buffer[7] [25]),
    .C1(_0293_),
    .C2(\buffer[2] [25]),
    .ZN(_0312_)
  );
  AOI222_X1 _0771_ (
    .A1(\buffer[3] [25]),
    .A2(_0286_),
    .B1(_0287_),
    .B2(\buffer[5] [25]),
    .C1(_0296_),
    .C2(\buffer[0] [25]),
    .ZN(_0313_)
  );
  AOI22_X1 _0772_ (
    .A1(\buffer[4] [25]),
    .A2(_0290_),
    .B1(_0295_),
    .B2(\buffer[1] [25]),
    .ZN(_0314_)
  );
  NAND3_X1 _0773_ (
    .A1(_0312_),
    .A2(_0313_),
    .A3(_0314_),
    .ZN(data_o[25])
  );
  AOI22_X1 _0774_ (
    .A1(\buffer[3] [24]),
    .A2(_0286_),
    .B1(_0287_),
    .B2(\buffer[5] [24]),
    .ZN(_0315_)
  );
  AOI222_X1 _0775_ (
    .A1(\buffer[4] [24]),
    .A2(_0290_),
    .B1(_0296_),
    .B2(\buffer[0] [24]),
    .C1(\buffer[6] [24]),
    .C2(_0289_),
    .ZN(_0316_)
  );
  AOI222_X1 _0776_ (
    .A1(\buffer[7] [24]),
    .A2(_0292_),
    .B1(_0293_),
    .B2(\buffer[2] [24]),
    .C1(\buffer[1] [24]),
    .C2(_0295_),
    .ZN(_0317_)
  );
  NAND3_X1 _0777_ (
    .A1(_0315_),
    .A2(_0316_),
    .A3(_0317_),
    .ZN(data_o[24])
  );
  AOI22_X1 _0778_ (
    .A1(\buffer[6] [23]),
    .A2(_0289_),
    .B1(_0293_),
    .B2(\buffer[2] [23]),
    .ZN(_0318_)
  );
  AOI222_X1 _0779_ (
    .A1(\buffer[3] [23]),
    .A2(_0286_),
    .B1(_0287_),
    .B2(\buffer[5] [23]),
    .C1(_0290_),
    .C2(\buffer[4] [23]),
    .ZN(_0319_)
  );
  AOI222_X1 _0780_ (
    .A1(\buffer[7] [23]),
    .A2(_0292_),
    .B1(_0295_),
    .B2(\buffer[1] [23]),
    .C1(_0296_),
    .C2(\buffer[0] [23]),
    .ZN(_0320_)
  );
  NAND3_X1 _0781_ (
    .A1(_0318_),
    .A2(_0319_),
    .A3(_0320_),
    .ZN(data_o[23])
  );
  AOI222_X1 _0782_ (
    .A1(\buffer[3] [22]),
    .A2(_0286_),
    .B1(_0290_),
    .B2(\buffer[4] [22]),
    .C1(_0292_),
    .C2(\buffer[7] [22]),
    .ZN(_0321_)
  );
  AOI222_X1 _0783_ (
    .A1(\buffer[5] [22]),
    .A2(_0287_),
    .B1(_0289_),
    .B2(\buffer[6] [22]),
    .C1(_0295_),
    .C2(\buffer[1] [22]),
    .ZN(_0322_)
  );
  AOI22_X1 _0784_ (
    .A1(\buffer[2] [22]),
    .A2(_0293_),
    .B1(_0296_),
    .B2(\buffer[0] [22]),
    .ZN(_0323_)
  );
  NAND3_X1 _0785_ (
    .A1(_0321_),
    .A2(_0322_),
    .A3(_0323_),
    .ZN(data_o[22])
  );
  AOI22_X1 _0786_ (
    .A1(\buffer[4] [21]),
    .A2(_0290_),
    .B1(_0296_),
    .B2(\buffer[0] [21]),
    .ZN(_0324_)
  );
  AOI22_X1 _0787_ (
    .A1(\buffer[5] [21]),
    .A2(_0287_),
    .B1(_0293_),
    .B2(\buffer[2] [21]),
    .ZN(_0325_)
  );
  AOI22_X1 _0788_ (
    .A1(\buffer[6] [21]),
    .A2(_0289_),
    .B1(_0292_),
    .B2(\buffer[7] [21]),
    .ZN(_0326_)
  );
  AOI22_X1 _0789_ (
    .A1(\buffer[3] [21]),
    .A2(_0286_),
    .B1(_0295_),
    .B2(\buffer[1] [21]),
    .ZN(_0327_)
  );
  NAND4_X1 _0790_ (
    .A1(_0324_),
    .A2(_0325_),
    .A3(_0326_),
    .A4(_0327_),
    .ZN(data_o[21])
  );
  AOI222_X1 _0791_ (
    .A1(\buffer[3] [20]),
    .A2(_0286_),
    .B1(_0287_),
    .B2(\buffer[5] [20]),
    .C1(\buffer[7] [20]),
    .C2(_0292_),
    .ZN(_0328_)
  );
  AOI222_X1 _0792_ (
    .A1(\buffer[4] [20]),
    .A2(_0290_),
    .B1(_0293_),
    .B2(\buffer[2] [20]),
    .C1(_0296_),
    .C2(\buffer[0] [20]),
    .ZN(_0329_)
  );
  AOI22_X1 _0793_ (
    .A1(\buffer[6] [20]),
    .A2(_0289_),
    .B1(_0295_),
    .B2(\buffer[1] [20]),
    .ZN(_0330_)
  );
  NAND3_X1 _0794_ (
    .A1(_0328_),
    .A2(_0329_),
    .A3(_0330_),
    .ZN(data_o[20])
  );
  AOI22_X1 _0795_ (
    .A1(\buffer[3] [19]),
    .A2(_0286_),
    .B1(_0287_),
    .B2(\buffer[5] [19]),
    .ZN(_0331_)
  );
  AOI22_X1 _0796_ (
    .A1(\buffer[6] [19]),
    .A2(_0289_),
    .B1(_0293_),
    .B2(\buffer[2] [19]),
    .ZN(_0332_)
  );
  NAND2_X1 _0797_ (
    .A1(\buffer[1] [19]),
    .A2(_0295_),
    .ZN(_0333_)
  );
  AOI222_X1 _0798_ (
    .A1(\buffer[4] [19]),
    .A2(_0290_),
    .B1(_0292_),
    .B2(\buffer[7] [19]),
    .C1(_0296_),
    .C2(\buffer[0] [19]),
    .ZN(_0334_)
  );
  NAND4_X1 _0799_ (
    .A1(_0331_),
    .A2(_0332_),
    .A3(_0333_),
    .A4(_0334_),
    .ZN(data_o[19])
  );
  AOI222_X1 _0800_ (
    .A1(\buffer[4] [18]),
    .A2(_0290_),
    .B1(_0295_),
    .B2(\buffer[1] [18]),
    .C1(\buffer[0] [18]),
    .C2(_0296_),
    .ZN(_0335_)
  );
  AOI22_X1 _0801_ (
    .A1(\buffer[5] [18]),
    .A2(_0287_),
    .B1(_0293_),
    .B2(\buffer[2] [18]),
    .ZN(_0336_)
  );
  AOI222_X1 _0802_ (
    .A1(\buffer[3] [18]),
    .A2(_0286_),
    .B1(_0289_),
    .B2(\buffer[6] [18]),
    .C1(_0292_),
    .C2(\buffer[7] [18]),
    .ZN(_0337_)
  );
  NAND3_X1 _0803_ (
    .A1(_0335_),
    .A2(_0336_),
    .A3(_0337_),
    .ZN(data_o[18])
  );
  AOI22_X1 _0804_ (
    .A1(\buffer[3] [17]),
    .A2(_0286_),
    .B1(_0296_),
    .B2(\buffer[0] [17]),
    .ZN(_0338_)
  );
  AOI22_X1 _0805_ (
    .A1(\buffer[5] [17]),
    .A2(_0287_),
    .B1(_0290_),
    .B2(\buffer[4] [17]),
    .ZN(_0339_)
  );
  NAND2_X1 _0806_ (
    .A1(\buffer[6] [17]),
    .A2(_0289_),
    .ZN(_0340_)
  );
  AOI222_X1 _0807_ (
    .A1(\buffer[2] [17]),
    .A2(_0293_),
    .B1(_0295_),
    .B2(\buffer[1] [17]),
    .C1(\buffer[7] [17]),
    .C2(_0292_),
    .ZN(_0341_)
  );
  NAND4_X1 _0808_ (
    .A1(_0338_),
    .A2(_0339_),
    .A3(_0340_),
    .A4(_0341_),
    .ZN(data_o[17])
  );
  AOI22_X1 _0809_ (
    .A1(\buffer[5] [16]),
    .A2(_0287_),
    .B1(_0290_),
    .B2(\buffer[4] [16]),
    .ZN(_0342_)
  );
  AOI22_X1 _0810_ (
    .A1(\buffer[3] [16]),
    .A2(_0286_),
    .B1(_0296_),
    .B2(\buffer[0] [16]),
    .ZN(_0343_)
  );
  AOI22_X1 _0811_ (
    .A1(\buffer[6] [16]),
    .A2(_0289_),
    .B1(_0293_),
    .B2(\buffer[2] [16]),
    .ZN(_0344_)
  );
  AOI22_X1 _0812_ (
    .A1(\buffer[7] [16]),
    .A2(_0292_),
    .B1(_0295_),
    .B2(\buffer[1] [16]),
    .ZN(_0345_)
  );
  NAND4_X1 _0813_ (
    .A1(_0342_),
    .A2(_0343_),
    .A3(_0344_),
    .A4(_0345_),
    .ZN(data_o[16])
  );
  AOI222_X1 _0814_ (
    .A1(\buffer[5] [15]),
    .A2(_0287_),
    .B1(_0289_),
    .B2(\buffer[6] [15]),
    .C1(_0295_),
    .C2(\buffer[1] [15]),
    .ZN(_0346_)
  );
  AOI222_X1 _0815_ (
    .A1(\buffer[4] [15]),
    .A2(_0290_),
    .B1(_0293_),
    .B2(\buffer[2] [15]),
    .C1(\buffer[3] [15]),
    .C2(_0286_),
    .ZN(_0347_)
  );
  AOI22_X1 _0816_ (
    .A1(\buffer[7] [15]),
    .A2(_0292_),
    .B1(_0296_),
    .B2(\buffer[0] [15]),
    .ZN(_0348_)
  );
  NAND3_X1 _0817_ (
    .A1(_0346_),
    .A2(_0347_),
    .A3(_0348_),
    .ZN(data_o[15])
  );
  AOI22_X1 _0818_ (
    .A1(\buffer[4] [14]),
    .A2(_0290_),
    .B1(_0293_),
    .B2(\buffer[2] [14]),
    .ZN(_0349_)
  );
  AOI22_X1 _0819_ (
    .A1(\buffer[5] [14]),
    .A2(_0287_),
    .B1(_0289_),
    .B2(\buffer[6] [14]),
    .ZN(_0350_)
  );
  AOI22_X1 _0820_ (
    .A1(\buffer[7] [14]),
    .A2(_0292_),
    .B1(_0295_),
    .B2(\buffer[1] [14]),
    .ZN(_0351_)
  );
  INV_X1 _0821_ (
    .A(_0351_),
    .ZN(_0352_)
  );
  AOI221_X1 _0822_ (
    .A(_0352_),
    .B1(_0286_),
    .B2(\buffer[3] [14]),
    .C1(\buffer[0] [14]),
    .C2(_0296_),
    .ZN(_0353_)
  );
  NAND3_X1 _0823_ (
    .A1(_0349_),
    .A2(_0350_),
    .A3(_0353_),
    .ZN(data_o[14])
  );
  AOI22_X1 _0824_ (
    .A1(\buffer[4] [13]),
    .A2(_0290_),
    .B1(_0296_),
    .B2(\buffer[0] [13]),
    .ZN(_0354_)
  );
  AOI22_X1 _0825_ (
    .A1(\buffer[3] [13]),
    .A2(_0286_),
    .B1(_0292_),
    .B2(\buffer[7] [13]),
    .ZN(_0355_)
  );
  NAND2_X1 _0826_ (
    .A1(\buffer[6] [13]),
    .A2(_0289_),
    .ZN(_0356_)
  );
  AOI222_X1 _0827_ (
    .A1(\buffer[5] [13]),
    .A2(_0287_),
    .B1(_0295_),
    .B2(\buffer[1] [13]),
    .C1(_0293_),
    .C2(\buffer[2] [13]),
    .ZN(_0357_)
  );
  NAND4_X1 _0828_ (
    .A1(_0354_),
    .A2(_0355_),
    .A3(_0356_),
    .A4(_0357_),
    .ZN(data_o[13])
  );
  AOI22_X1 _0829_ (
    .A1(\buffer[3] [12]),
    .A2(_0286_),
    .B1(_0295_),
    .B2(\buffer[1] [12]),
    .ZN(_0358_)
  );
  AOI222_X1 _0830_ (
    .A1(\buffer[4] [12]),
    .A2(_0290_),
    .B1(_0292_),
    .B2(\buffer[7] [12]),
    .C1(_0296_),
    .C2(\buffer[0] [12]),
    .ZN(_0359_)
  );
  AOI222_X1 _0831_ (
    .A1(\buffer[5] [12]),
    .A2(_0287_),
    .B1(_0289_),
    .B2(\buffer[6] [12]),
    .C1(_0293_),
    .C2(\buffer[2] [12]),
    .ZN(_0360_)
  );
  NAND3_X1 _0832_ (
    .A1(_0358_),
    .A2(_0359_),
    .A3(_0360_),
    .ZN(data_o[12])
  );
  AOI22_X1 _0833_ (
    .A1(\buffer[5] [11]),
    .A2(_0287_),
    .B1(_0296_),
    .B2(\buffer[0] [11]),
    .ZN(_0361_)
  );
  INV_X1 _0834_ (
    .A(_0361_),
    .ZN(_0362_)
  );
  AOI221_X1 _0835_ (
    .A(_0362_),
    .B1(_0289_),
    .B2(\buffer[6] [11]),
    .C1(\buffer[7] [11]),
    .C2(_0292_),
    .ZN(_0363_)
  );
  AOI22_X1 _0836_ (
    .A1(\buffer[2] [11]),
    .A2(_0293_),
    .B1(_0295_),
    .B2(\buffer[1] [11]),
    .ZN(_0364_)
  );
  AOI22_X1 _0837_ (
    .A1(\buffer[3] [11]),
    .A2(_0286_),
    .B1(_0290_),
    .B2(\buffer[4] [11]),
    .ZN(_0365_)
  );
  NAND3_X1 _0838_ (
    .A1(_0363_),
    .A2(_0364_),
    .A3(_0365_),
    .ZN(data_o[11])
  );
  AOI222_X1 _0839_ (
    .A1(\buffer[3] [10]),
    .A2(_0286_),
    .B1(_0290_),
    .B2(\buffer[4] [10]),
    .C1(_0296_),
    .C2(\buffer[0] [10]),
    .ZN(_0366_)
  );
  AOI222_X1 _0840_ (
    .A1(\buffer[5] [10]),
    .A2(_0287_),
    .B1(_0289_),
    .B2(\buffer[6] [10]),
    .C1(_0295_),
    .C2(\buffer[1] [10]),
    .ZN(_0367_)
  );
  AOI22_X1 _0841_ (
    .A1(\buffer[7] [10]),
    .A2(_0292_),
    .B1(_0293_),
    .B2(\buffer[2] [10]),
    .ZN(_0368_)
  );
  NAND3_X1 _0842_ (
    .A1(_0366_),
    .A2(_0367_),
    .A3(_0368_),
    .ZN(data_o[10])
  );
  AOI222_X1 _0843_ (
    .A1(\buffer[5] [9]),
    .A2(_0287_),
    .B1(_0290_),
    .B2(\buffer[4] [9]),
    .C1(_0293_),
    .C2(\buffer[2] [9]),
    .ZN(_0369_)
  );
  AOI222_X1 _0844_ (
    .A1(\buffer[3] [9]),
    .A2(_0286_),
    .B1(_0289_),
    .B2(\buffer[6] [9]),
    .C1(_0292_),
    .C2(\buffer[7] [9]),
    .ZN(_0370_)
  );
  AOI22_X1 _0845_ (
    .A1(\buffer[1] [9]),
    .A2(_0295_),
    .B1(_0296_),
    .B2(\buffer[0] [9]),
    .ZN(_0371_)
  );
  NAND3_X1 _0846_ (
    .A1(_0369_),
    .A2(_0370_),
    .A3(_0371_),
    .ZN(data_o[9])
  );
  AOI22_X1 _0847_ (
    .A1(\buffer[6] [8]),
    .A2(_0289_),
    .B1(_0293_),
    .B2(\buffer[2] [8]),
    .ZN(_0372_)
  );
  INV_X1 _0848_ (
    .A(_0372_),
    .ZN(_0373_)
  );
  AOI221_X1 _0849_ (
    .A(_0373_),
    .B1(_0295_),
    .B2(\buffer[1] [8]),
    .C1(\buffer[3] [8]),
    .C2(_0286_),
    .ZN(_0374_)
  );
  AOI22_X1 _0850_ (
    .A1(\buffer[5] [8]),
    .A2(_0287_),
    .B1(_0296_),
    .B2(\buffer[0] [8]),
    .ZN(_0375_)
  );
  AOI22_X1 _0851_ (
    .A1(\buffer[4] [8]),
    .A2(_0290_),
    .B1(_0292_),
    .B2(\buffer[7] [8]),
    .ZN(_0376_)
  );
  NAND3_X1 _0852_ (
    .A1(_0374_),
    .A2(_0375_),
    .A3(_0376_),
    .ZN(data_o[8])
  );
  AOI22_X1 _0853_ (
    .A1(\buffer[5] [7]),
    .A2(_0287_),
    .B1(_0295_),
    .B2(\buffer[1] [7]),
    .ZN(_0377_)
  );
  INV_X1 _0854_ (
    .A(_0377_),
    .ZN(_0378_)
  );
  AOI221_X1 _0855_ (
    .A(_0378_),
    .B1(_0292_),
    .B2(\buffer[7] [7]),
    .C1(\buffer[6] [7]),
    .C2(_0289_),
    .ZN(_0379_)
  );
  AOI22_X1 _0856_ (
    .A1(\buffer[3] [7]),
    .A2(_0286_),
    .B1(_0293_),
    .B2(\buffer[2] [7]),
    .ZN(_0380_)
  );
  AOI22_X1 _0857_ (
    .A1(\buffer[4] [7]),
    .A2(_0290_),
    .B1(_0296_),
    .B2(\buffer[0] [7]),
    .ZN(_0381_)
  );
  NAND3_X1 _0858_ (
    .A1(_0379_),
    .A2(_0380_),
    .A3(_0381_),
    .ZN(data_o[7])
  );
  AOI22_X1 _0859_ (
    .A1(\buffer[5] [6]),
    .A2(_0287_),
    .B1(_0293_),
    .B2(\buffer[2] [6]),
    .ZN(_0382_)
  );
  AOI22_X1 _0860_ (
    .A1(\buffer[3] [6]),
    .A2(_0286_),
    .B1(_0296_),
    .B2(\buffer[0] [6]),
    .ZN(_0383_)
  );
  NAND2_X1 _0861_ (
    .A1(\buffer[7] [6]),
    .A2(_0292_),
    .ZN(_0384_)
  );
  AOI222_X1 _0862_ (
    .A1(\buffer[6] [6]),
    .A2(_0289_),
    .B1(_0290_),
    .B2(\buffer[4] [6]),
    .C1(_0295_),
    .C2(\buffer[1] [6]),
    .ZN(_0385_)
  );
  NAND4_X1 _0863_ (
    .A1(_0382_),
    .A2(_0383_),
    .A3(_0384_),
    .A4(_0385_),
    .ZN(data_o[6])
  );
  AOI22_X1 _0864_ (
    .A1(\buffer[5] [5]),
    .A2(_0287_),
    .B1(_0289_),
    .B2(\buffer[6] [5]),
    .ZN(_0386_)
  );
  AOI22_X1 _0865_ (
    .A1(\buffer[2] [5]),
    .A2(_0293_),
    .B1(_0295_),
    .B2(\buffer[1] [5]),
    .ZN(_0387_)
  );
  NAND2_X1 _0866_ (
    .A1(\buffer[7] [5]),
    .A2(_0292_),
    .ZN(_0388_)
  );
  AOI222_X1 _0867_ (
    .A1(\buffer[3] [5]),
    .A2(_0286_),
    .B1(_0290_),
    .B2(\buffer[4] [5]),
    .C1(\buffer[0] [5]),
    .C2(_0296_),
    .ZN(_0389_)
  );
  NAND4_X1 _0868_ (
    .A1(_0386_),
    .A2(_0387_),
    .A3(_0388_),
    .A4(_0389_),
    .ZN(data_o[5])
  );
  AOI22_X1 _0869_ (
    .A1(\buffer[3] [4]),
    .A2(_0286_),
    .B1(_0290_),
    .B2(\buffer[4] [4]),
    .ZN(_0390_)
  );
  AOI222_X1 _0870_ (
    .A1(\buffer[5] [4]),
    .A2(_0287_),
    .B1(_0293_),
    .B2(\buffer[2] [4]),
    .C1(\buffer[1] [4]),
    .C2(_0295_),
    .ZN(_0391_)
  );
  AOI222_X1 _0871_ (
    .A1(\buffer[6] [4]),
    .A2(_0289_),
    .B1(_0292_),
    .B2(\buffer[7] [4]),
    .C1(_0296_),
    .C2(\buffer[0] [4]),
    .ZN(_0392_)
  );
  NAND3_X1 _0872_ (
    .A1(_0390_),
    .A2(_0391_),
    .A3(_0392_),
    .ZN(data_o[4])
  );
  AOI222_X1 _0873_ (
    .A1(\buffer[5] [3]),
    .A2(_0287_),
    .B1(_0290_),
    .B2(\buffer[4] [3]),
    .C1(_0293_),
    .C2(\buffer[2] [3]),
    .ZN(_0393_)
  );
  AOI222_X1 _0874_ (
    .A1(\buffer[3] [3]),
    .A2(_0286_),
    .B1(_0292_),
    .B2(\buffer[7] [3]),
    .C1(_0295_),
    .C2(\buffer[1] [3]),
    .ZN(_0394_)
  );
  AOI22_X1 _0875_ (
    .A1(\buffer[6] [3]),
    .A2(_0289_),
    .B1(_0296_),
    .B2(\buffer[0] [3]),
    .ZN(_0395_)
  );
  NAND3_X1 _0876_ (
    .A1(_0393_),
    .A2(_0394_),
    .A3(_0395_),
    .ZN(data_o[3])
  );
  AOI222_X1 _0877_ (
    .A1(\buffer[5] [2]),
    .A2(_0287_),
    .B1(_0293_),
    .B2(\buffer[2] [2]),
    .C1(\buffer[3] [2]),
    .C2(_0286_),
    .ZN(_0396_)
  );
  AOI222_X1 _0878_ (
    .A1(\buffer[4] [2]),
    .A2(_0290_),
    .B1(_0292_),
    .B2(\buffer[7] [2]),
    .C1(\buffer[1] [2]),
    .C2(_0295_),
    .ZN(_0397_)
  );
  AOI22_X1 _0879_ (
    .A1(\buffer[6] [2]),
    .A2(_0289_),
    .B1(_0296_),
    .B2(\buffer[0] [2]),
    .ZN(_0398_)
  );
  NAND3_X1 _0880_ (
    .A1(_0396_),
    .A2(_0397_),
    .A3(_0398_),
    .ZN(data_o[2])
  );
  AOI22_X1 _0881_ (
    .A1(\buffer[2] [1]),
    .A2(_0293_),
    .B1(_0295_),
    .B2(\buffer[1] [1]),
    .ZN(_0399_)
  );
  INV_X1 _0882_ (
    .A(_0399_),
    .ZN(_0400_)
  );
  AOI221_X1 _0883_ (
    .A(_0400_),
    .B1(_0287_),
    .B2(\buffer[5] [1]),
    .C1(\buffer[3] [1]),
    .C2(_0286_),
    .ZN(_0401_)
  );
  AOI22_X1 _0884_ (
    .A1(\buffer[6] [1]),
    .A2(_0289_),
    .B1(_0292_),
    .B2(\buffer[7] [1]),
    .ZN(_0402_)
  );
  AOI22_X1 _0885_ (
    .A1(\buffer[4] [1]),
    .A2(_0290_),
    .B1(_0296_),
    .B2(\buffer[0] [1]),
    .ZN(_0403_)
  );
  NAND3_X1 _0886_ (
    .A1(_0401_),
    .A2(_0402_),
    .A3(_0403_),
    .ZN(data_o[1])
  );
  AOI22_X1 _0887_ (
    .A1(\buffer[6] [0]),
    .A2(_0289_),
    .B1(_0295_),
    .B2(\buffer[1] [0]),
    .ZN(_0404_)
  );
  AOI222_X1 _0888_ (
    .A1(\buffer[3] [0]),
    .A2(_0286_),
    .B1(_0292_),
    .B2(\buffer[7] [0]),
    .C1(_0296_),
    .C2(\buffer[0] [0]),
    .ZN(_0405_)
  );
  AOI222_X1 _0889_ (
    .A1(\buffer[5] [0]),
    .A2(_0287_),
    .B1(_0293_),
    .B2(\buffer[2] [0]),
    .C1(_0290_),
    .C2(\buffer[4] [0]),
    .ZN(_0406_)
  );
  NAND3_X1 _0890_ (
    .A1(_0404_),
    .A2(_0405_),
    .A3(_0406_),
    .ZN(data_o[0])
  );
  NOR4_X1 _0891_ (
    .A1(elements[2]),
    .A2(elements[4]),
    .A3(elements[0]),
    .A4(elements[1]),
    .ZN(_0407_)
  );
  OR4_X1 _0892_ (
    .A1(elements[2]),
    .A2(elements[4]),
    .A3(elements[0]),
    .A4(elements[1]),
    .ZN(_0408_)
  );
  NAND2_X1 _0893_ (
    .A1(_0278_),
    .A2(_0407_),
    .ZN(valid_o)
  );
  NAND2_X1 _0894_ (
    .A1(_0280_),
    .A2(_0407_),
    .ZN(ready_o)
  );
  AOI222_X1 _0895_ (
    .A1(\buffer[5] [31]),
    .A2(_0287_),
    .B1(_0289_),
    .B2(\buffer[6] [31]),
    .C1(\buffer[1] [31]),
    .C2(_0295_),
    .ZN(_0409_)
  );
  AOI222_X1 _0896_ (
    .A1(\buffer[3] [31]),
    .A2(_0286_),
    .B1(_0293_),
    .B2(\buffer[2] [31]),
    .C1(_0290_),
    .C2(\buffer[4] [31]),
    .ZN(_0410_)
  );
  AOI22_X1 _0897_ (
    .A1(\buffer[7] [31]),
    .A2(_0292_),
    .B1(_0296_),
    .B2(\buffer[0] [31]),
    .ZN(_0411_)
  );
  NAND3_X1 _0898_ (
    .A1(_0409_),
    .A2(_0410_),
    .A3(_0411_),
    .ZN(data_o[31])
  );
  AOI21_X1 _0899_ (
    .A(_0281_),
    .B1(_0407_),
    .B2(_0280_),
    .ZN(_0412_)
  );
  OAI21_X1 _0900_ (
    .A(valid_i),
    .B1(_0408_),
    .B2(_0000_),
    .ZN(_0413_)
  );
  NOR3_X1 _0901_ (
    .A1(_0283_),
    .A2(_0284_),
    .A3(_0413_),
    .ZN(_0414_)
  );
  NAND2_X1 _0902_ (
    .A1(pointer_in[2]),
    .A2(_0414_),
    .ZN(_0415_)
  );
  MUX2_X1 _0903_ (
    .A(data_i[21]),
    .B(\buffer[7] [21]),
    .S(_0415_),
    .Z(_0001_)
  );
  MUX2_X1 _0904_ (
    .A(data_i[20]),
    .B(\buffer[7] [20]),
    .S(_0415_),
    .Z(_0002_)
  );
  MUX2_X1 _0905_ (
    .A(data_i[19]),
    .B(\buffer[7] [19]),
    .S(_0415_),
    .Z(_0003_)
  );
  MUX2_X1 _0906_ (
    .A(data_i[18]),
    .B(\buffer[7] [18]),
    .S(_0415_),
    .Z(_0004_)
  );
  MUX2_X1 _0907_ (
    .A(data_i[17]),
    .B(\buffer[7] [17]),
    .S(_0415_),
    .Z(_0005_)
  );
  MUX2_X1 _0908_ (
    .A(data_i[16]),
    .B(\buffer[7] [16]),
    .S(_0415_),
    .Z(_0006_)
  );
  MUX2_X1 _0909_ (
    .A(data_i[15]),
    .B(\buffer[7] [15]),
    .S(_0415_),
    .Z(_0007_)
  );
  MUX2_X1 _0910_ (
    .A(data_i[14]),
    .B(\buffer[7] [14]),
    .S(_0415_),
    .Z(_0008_)
  );
  MUX2_X1 _0911_ (
    .A(data_i[13]),
    .B(\buffer[7] [13]),
    .S(_0415_),
    .Z(_0009_)
  );
  MUX2_X1 _0912_ (
    .A(data_i[12]),
    .B(\buffer[7] [12]),
    .S(_0415_),
    .Z(_0010_)
  );
  MUX2_X1 _0913_ (
    .A(data_i[11]),
    .B(\buffer[7] [11]),
    .S(_0415_),
    .Z(_0011_)
  );
  MUX2_X1 _0914_ (
    .A(data_i[10]),
    .B(\buffer[7] [10]),
    .S(_0415_),
    .Z(_0012_)
  );
  MUX2_X1 _0915_ (
    .A(data_i[9]),
    .B(\buffer[7] [9]),
    .S(_0415_),
    .Z(_0013_)
  );
  MUX2_X1 _0916_ (
    .A(data_i[8]),
    .B(\buffer[7] [8]),
    .S(_0415_),
    .Z(_0014_)
  );
  MUX2_X1 _0917_ (
    .A(data_i[7]),
    .B(\buffer[7] [7]),
    .S(_0415_),
    .Z(_0015_)
  );
  MUX2_X1 _0918_ (
    .A(data_i[6]),
    .B(\buffer[7] [6]),
    .S(_0415_),
    .Z(_0016_)
  );
  MUX2_X1 _0919_ (
    .A(data_i[5]),
    .B(\buffer[7] [5]),
    .S(_0415_),
    .Z(_0017_)
  );
  MUX2_X1 _0920_ (
    .A(data_i[4]),
    .B(\buffer[7] [4]),
    .S(_0415_),
    .Z(_0018_)
  );
  MUX2_X1 _0921_ (
    .A(data_i[3]),
    .B(\buffer[7] [3]),
    .S(_0415_),
    .Z(_0019_)
  );
  MUX2_X1 _0922_ (
    .A(data_i[2]),
    .B(\buffer[7] [2]),
    .S(_0415_),
    .Z(_0020_)
  );
  MUX2_X1 _0923_ (
    .A(data_i[1]),
    .B(\buffer[7] [1]),
    .S(_0415_),
    .Z(_0021_)
  );
  MUX2_X1 _0924_ (
    .A(data_i[0]),
    .B(\buffer[7] [0]),
    .S(_0415_),
    .Z(_0022_)
  );
  AOI21_X1 _0925_ (
    .A(_0279_),
    .B1(_0407_),
    .B2(_0278_),
    .ZN(_0416_)
  );
  OAI21_X1 _0926_ (
    .A(ready_i),
    .B1(_0408_),
    .B2(elements[3]),
    .ZN(_0417_)
  );
  NOR2_X1 _0927_ (
    .A1(_0412_),
    .A2(_0417_),
    .ZN(_0418_)
  );
  NAND2_X1 _0928_ (
    .A1(_0413_),
    .A2(_0416_),
    .ZN(_0419_)
  );
  AOI21_X1 _0929_ (
    .A(clr_i),
    .B1(_0412_),
    .B2(_0417_),
    .ZN(_0420_)
  );
  AND2_X1 _0930_ (
    .A1(_0419_),
    .A2(_0420_),
    .ZN(_0421_)
  );
  NAND2_X1 _0931_ (
    .A1(_0419_),
    .A2(_0420_),
    .ZN(_0422_)
  );
  NAND2_X1 _0932_ (
    .A1(elements[2]),
    .A2(_0418_),
    .ZN(_0423_)
  );
  NOR3_X1 _0933_ (
    .A1(_0277_),
    .A2(_0279_),
    .A3(_0412_),
    .ZN(_0424_)
  );
  NAND3_X1 _0934_ (
    .A1(elements[1]),
    .A2(ready_i),
    .A3(_0413_),
    .ZN(_0425_)
  );
  AOI21_X1 _0935_ (
    .A(elements[1]),
    .B1(_0413_),
    .B2(_0416_),
    .ZN(_0426_)
  );
  OAI21_X1 _0936_ (
    .A(_0277_),
    .B1(_0412_),
    .B2(_0417_),
    .ZN(_0427_)
  );
  NOR2_X1 _0937_ (
    .A1(_0424_),
    .A2(_0426_),
    .ZN(_0428_)
  );
  AOI21_X1 _0938_ (
    .A(_0424_),
    .B1(_0427_),
    .B2(elements[0]),
    .ZN(_0429_)
  );
  OAI21_X1 _0939_ (
    .A(_0425_),
    .B1(_0426_),
    .B2(_0276_),
    .ZN(_0430_)
  );
  NOR2_X1 _0940_ (
    .A1(elements[2]),
    .A2(_0418_),
    .ZN(_0431_)
  );
  XNOR2_X1 _0941_ (
    .A(_0275_),
    .B(_0418_),
    .ZN(_0432_)
  );
  NAND2_X1 _0942_ (
    .A1(_0430_),
    .A2(_0432_),
    .ZN(_0433_)
  );
  OAI21_X1 _0943_ (
    .A(_0423_),
    .B1(_0429_),
    .B2(_0431_),
    .ZN(_0434_)
  );
  XNOR2_X1 _0944_ (
    .A(elements[3]),
    .B(_0418_),
    .ZN(_0435_)
  );
  NOR2_X1 _0945_ (
    .A1(clr_i),
    .A2(_0421_),
    .ZN(_0436_)
  );
  XNOR2_X1 _0946_ (
    .A(_0434_),
    .B(_0435_),
    .ZN(_0437_)
  );
  NAND2_X1 _0947_ (
    .A1(_0436_),
    .A2(_0437_),
    .ZN(_0438_)
  );
  OAI21_X1 _0948_ (
    .A(_0438_),
    .B1(_0422_),
    .B2(_0278_),
    .ZN(_0023_)
  );
  NOR2_X1 _0949_ (
    .A1(_0430_),
    .A2(_0432_),
    .ZN(_0439_)
  );
  NAND2_X1 _0950_ (
    .A1(_0433_),
    .A2(_0436_),
    .ZN(_0440_)
  );
  OAI22_X1 _0951_ (
    .A1(_0275_),
    .A2(_0422_),
    .B1(_0439_),
    .B2(_0440_),
    .ZN(_0024_)
  );
  XNOR2_X1 _0952_ (
    .A(_0276_),
    .B(_0428_),
    .ZN(_0441_)
  );
  AOI22_X1 _0953_ (
    .A1(elements[1]),
    .A2(_0421_),
    .B1(_0436_),
    .B2(_0441_),
    .ZN(_0442_)
  );
  INV_X1 _0954_ (
    .A(_0442_),
    .ZN(_0025_)
  );
  MUX2_X1 _0955_ (
    .A(_0421_),
    .B(_0436_),
    .S(_0276_),
    .Z(_0026_)
  );
  NOR4_X1 _0956_ (
    .A1(pointer_in[1]),
    .A2(pointer_in[0]),
    .A3(pointer_in[2]),
    .A4(_0413_),
    .ZN(_0443_)
  );
  MUX2_X1 _0957_ (
    .A(\buffer[0] [30]),
    .B(data_i[30]),
    .S(_0443_),
    .Z(_0027_)
  );
  NOR2_X1 _0958_ (
    .A1(_0285_),
    .A2(_0417_),
    .ZN(_0444_)
  );
  OAI21_X1 _0959_ (
    .A(_0282_),
    .B1(_0444_),
    .B2(pointer_out[2]),
    .ZN(_0445_)
  );
  AOI21_X1 _0960_ (
    .A(_0445_),
    .B1(_0444_),
    .B2(pointer_out[2]),
    .ZN(_0028_)
  );
  AOI21_X1 _0961_ (
    .A(pointer_out[1]),
    .B1(_0416_),
    .B2(pointer_out[0]),
    .ZN(_0446_)
  );
  NOR3_X1 _0962_ (
    .A1(clr_i),
    .A2(_0444_),
    .A3(_0446_),
    .ZN(_0029_)
  );
  OAI21_X1 _0963_ (
    .A(_0282_),
    .B1(_0417_),
    .B2(_0272_),
    .ZN(_0447_)
  );
  AOI21_X1 _0964_ (
    .A(_0447_),
    .B1(_0417_),
    .B2(_0272_),
    .ZN(_0030_)
  );
  OAI21_X1 _0965_ (
    .A(_0282_),
    .B1(pointer_in[2]),
    .B2(_0414_),
    .ZN(_0448_)
  );
  AOI21_X1 _0966_ (
    .A(_0448_),
    .B1(_0414_),
    .B2(pointer_in[2]),
    .ZN(_0031_)
  );
  AOI21_X1 _0967_ (
    .A(pointer_in[1]),
    .B1(pointer_in[0]),
    .B2(_0412_),
    .ZN(_0449_)
  );
  NOR3_X1 _0968_ (
    .A1(clr_i),
    .A2(_0414_),
    .A3(_0449_),
    .ZN(_0032_)
  );
  OAI21_X1 _0969_ (
    .A(_0282_),
    .B1(_0284_),
    .B2(_0413_),
    .ZN(_0450_)
  );
  AOI21_X1 _0970_ (
    .A(_0450_),
    .B1(_0413_),
    .B2(_0284_),
    .ZN(_0033_)
  );
  NAND2_X1 _0971_ (
    .A1(pointer_in[1]),
    .A2(_0284_),
    .ZN(_0451_)
  );
  NOR3_X1 _0972_ (
    .A1(pointer_in[2]),
    .A2(_0413_),
    .A3(_0451_),
    .ZN(_0452_)
  );
  MUX2_X1 _0973_ (
    .A(\buffer[2] [30]),
    .B(data_i[30]),
    .S(_0452_),
    .Z(_0034_)
  );
  MUX2_X1 _0974_ (
    .A(\buffer[2] [29]),
    .B(data_i[29]),
    .S(_0452_),
    .Z(_0035_)
  );
  MUX2_X1 _0975_ (
    .A(\buffer[2] [28]),
    .B(data_i[28]),
    .S(_0452_),
    .Z(_0036_)
  );
  MUX2_X1 _0976_ (
    .A(\buffer[2] [27]),
    .B(data_i[27]),
    .S(_0452_),
    .Z(_0037_)
  );
  MUX2_X1 _0977_ (
    .A(\buffer[2] [26]),
    .B(data_i[26]),
    .S(_0452_),
    .Z(_0038_)
  );
  MUX2_X1 _0978_ (
    .A(\buffer[2] [25]),
    .B(data_i[25]),
    .S(_0452_),
    .Z(_0039_)
  );
  MUX2_X1 _0979_ (
    .A(\buffer[2] [24]),
    .B(data_i[24]),
    .S(_0452_),
    .Z(_0040_)
  );
  MUX2_X1 _0980_ (
    .A(\buffer[2] [23]),
    .B(data_i[23]),
    .S(_0452_),
    .Z(_0041_)
  );
  MUX2_X1 _0981_ (
    .A(\buffer[2] [22]),
    .B(data_i[22]),
    .S(_0452_),
    .Z(_0042_)
  );
  MUX2_X1 _0982_ (
    .A(\buffer[2] [21]),
    .B(data_i[21]),
    .S(_0452_),
    .Z(_0043_)
  );
  MUX2_X1 _0983_ (
    .A(\buffer[2] [20]),
    .B(data_i[20]),
    .S(_0452_),
    .Z(_0044_)
  );
  MUX2_X1 _0984_ (
    .A(\buffer[2] [19]),
    .B(data_i[19]),
    .S(_0452_),
    .Z(_0045_)
  );
  MUX2_X1 _0985_ (
    .A(\buffer[2] [18]),
    .B(data_i[18]),
    .S(_0452_),
    .Z(_0046_)
  );
  MUX2_X1 _0986_ (
    .A(\buffer[2] [17]),
    .B(data_i[17]),
    .S(_0452_),
    .Z(_0047_)
  );
  MUX2_X1 _0987_ (
    .A(\buffer[2] [16]),
    .B(data_i[16]),
    .S(_0452_),
    .Z(_0048_)
  );
  MUX2_X1 _0988_ (
    .A(\buffer[2] [15]),
    .B(data_i[15]),
    .S(_0452_),
    .Z(_0049_)
  );
  MUX2_X1 _0989_ (
    .A(\buffer[2] [14]),
    .B(data_i[14]),
    .S(_0452_),
    .Z(_0050_)
  );
  MUX2_X1 _0990_ (
    .A(\buffer[2] [13]),
    .B(data_i[13]),
    .S(_0452_),
    .Z(_0051_)
  );
  MUX2_X1 _0991_ (
    .A(\buffer[2] [12]),
    .B(data_i[12]),
    .S(_0452_),
    .Z(_0052_)
  );
  MUX2_X1 _0992_ (
    .A(\buffer[2] [11]),
    .B(data_i[11]),
    .S(_0452_),
    .Z(_0053_)
  );
  MUX2_X1 _0993_ (
    .A(\buffer[2] [10]),
    .B(data_i[10]),
    .S(_0452_),
    .Z(_0054_)
  );
  MUX2_X1 _0994_ (
    .A(\buffer[2] [9]),
    .B(data_i[9]),
    .S(_0452_),
    .Z(_0055_)
  );
  MUX2_X1 _0995_ (
    .A(\buffer[2] [8]),
    .B(data_i[8]),
    .S(_0452_),
    .Z(_0056_)
  );
  MUX2_X1 _0996_ (
    .A(\buffer[2] [7]),
    .B(data_i[7]),
    .S(_0452_),
    .Z(_0057_)
  );
  MUX2_X1 _0997_ (
    .A(\buffer[2] [6]),
    .B(data_i[6]),
    .S(_0452_),
    .Z(_0058_)
  );
  MUX2_X1 _0998_ (
    .A(\buffer[2] [5]),
    .B(data_i[5]),
    .S(_0452_),
    .Z(_0059_)
  );
  MUX2_X1 _0999_ (
    .A(\buffer[2] [4]),
    .B(data_i[4]),
    .S(_0452_),
    .Z(_0060_)
  );
  MUX2_X1 _1000_ (
    .A(\buffer[2] [3]),
    .B(data_i[3]),
    .S(_0452_),
    .Z(_0061_)
  );
  MUX2_X1 _1001_ (
    .A(\buffer[2] [2]),
    .B(data_i[2]),
    .S(_0452_),
    .Z(_0062_)
  );
  MUX2_X1 _1002_ (
    .A(\buffer[2] [1]),
    .B(data_i[1]),
    .S(_0452_),
    .Z(_0063_)
  );
  MUX2_X1 _1003_ (
    .A(\buffer[2] [0]),
    .B(data_i[0]),
    .S(_0452_),
    .Z(_0064_)
  );
  NAND2_X1 _1004_ (
    .A1(_0283_),
    .A2(pointer_in[0]),
    .ZN(_0453_)
  );
  NOR3_X1 _1005_ (
    .A1(pointer_in[2]),
    .A2(_0413_),
    .A3(_0453_),
    .ZN(_0454_)
  );
  MUX2_X1 _1006_ (
    .A(\buffer[1] [30]),
    .B(data_i[30]),
    .S(_0454_),
    .Z(_0065_)
  );
  MUX2_X1 _1007_ (
    .A(\buffer[1] [29]),
    .B(data_i[29]),
    .S(_0454_),
    .Z(_0066_)
  );
  MUX2_X1 _1008_ (
    .A(\buffer[1] [28]),
    .B(data_i[28]),
    .S(_0454_),
    .Z(_0067_)
  );
  MUX2_X1 _1009_ (
    .A(\buffer[1] [27]),
    .B(data_i[27]),
    .S(_0454_),
    .Z(_0068_)
  );
  MUX2_X1 _1010_ (
    .A(\buffer[1] [26]),
    .B(data_i[26]),
    .S(_0454_),
    .Z(_0069_)
  );
  MUX2_X1 _1011_ (
    .A(\buffer[1] [25]),
    .B(data_i[25]),
    .S(_0454_),
    .Z(_0070_)
  );
  MUX2_X1 _1012_ (
    .A(\buffer[1] [24]),
    .B(data_i[24]),
    .S(_0454_),
    .Z(_0071_)
  );
  MUX2_X1 _1013_ (
    .A(\buffer[1] [23]),
    .B(data_i[23]),
    .S(_0454_),
    .Z(_0072_)
  );
  MUX2_X1 _1014_ (
    .A(\buffer[1] [22]),
    .B(data_i[22]),
    .S(_0454_),
    .Z(_0073_)
  );
  MUX2_X1 _1015_ (
    .A(\buffer[1] [21]),
    .B(data_i[21]),
    .S(_0454_),
    .Z(_0074_)
  );
  MUX2_X1 _1016_ (
    .A(\buffer[1] [20]),
    .B(data_i[20]),
    .S(_0454_),
    .Z(_0075_)
  );
  MUX2_X1 _1017_ (
    .A(\buffer[1] [19]),
    .B(data_i[19]),
    .S(_0454_),
    .Z(_0076_)
  );
  MUX2_X1 _1018_ (
    .A(\buffer[1] [18]),
    .B(data_i[18]),
    .S(_0454_),
    .Z(_0077_)
  );
  MUX2_X1 _1019_ (
    .A(\buffer[1] [17]),
    .B(data_i[17]),
    .S(_0454_),
    .Z(_0078_)
  );
  MUX2_X1 _1020_ (
    .A(\buffer[1] [16]),
    .B(data_i[16]),
    .S(_0454_),
    .Z(_0079_)
  );
  MUX2_X1 _1021_ (
    .A(\buffer[1] [15]),
    .B(data_i[15]),
    .S(_0454_),
    .Z(_0080_)
  );
  MUX2_X1 _1022_ (
    .A(\buffer[1] [14]),
    .B(data_i[14]),
    .S(_0454_),
    .Z(_0081_)
  );
  MUX2_X1 _1023_ (
    .A(\buffer[1] [13]),
    .B(data_i[13]),
    .S(_0454_),
    .Z(_0082_)
  );
  MUX2_X1 _1024_ (
    .A(\buffer[1] [12]),
    .B(data_i[12]),
    .S(_0454_),
    .Z(_0083_)
  );
  MUX2_X1 _1025_ (
    .A(\buffer[1] [11]),
    .B(data_i[11]),
    .S(_0454_),
    .Z(_0084_)
  );
  MUX2_X1 _1026_ (
    .A(\buffer[1] [10]),
    .B(data_i[10]),
    .S(_0454_),
    .Z(_0085_)
  );
  MUX2_X1 _1027_ (
    .A(\buffer[1] [9]),
    .B(data_i[9]),
    .S(_0454_),
    .Z(_0086_)
  );
  MUX2_X1 _1028_ (
    .A(\buffer[1] [8]),
    .B(data_i[8]),
    .S(_0454_),
    .Z(_0087_)
  );
  MUX2_X1 _1029_ (
    .A(\buffer[1] [7]),
    .B(data_i[7]),
    .S(_0454_),
    .Z(_0088_)
  );
  MUX2_X1 _1030_ (
    .A(\buffer[1] [6]),
    .B(data_i[6]),
    .S(_0454_),
    .Z(_0089_)
  );
  MUX2_X1 _1031_ (
    .A(\buffer[1] [5]),
    .B(data_i[5]),
    .S(_0454_),
    .Z(_0090_)
  );
  MUX2_X1 _1032_ (
    .A(\buffer[1] [4]),
    .B(data_i[4]),
    .S(_0454_),
    .Z(_0091_)
  );
  MUX2_X1 _1033_ (
    .A(\buffer[1] [3]),
    .B(data_i[3]),
    .S(_0454_),
    .Z(_0092_)
  );
  MUX2_X1 _1034_ (
    .A(\buffer[1] [2]),
    .B(data_i[2]),
    .S(_0454_),
    .Z(_0093_)
  );
  MUX2_X1 _1035_ (
    .A(\buffer[1] [1]),
    .B(data_i[1]),
    .S(_0454_),
    .Z(_0094_)
  );
  MUX2_X1 _1036_ (
    .A(\buffer[1] [0]),
    .B(data_i[0]),
    .S(_0454_),
    .Z(_0095_)
  );
  NAND2_X1 _1037_ (
    .A1(pointer_in[2]),
    .A2(_0412_),
    .ZN(_0455_)
  );
  NOR2_X1 _1038_ (
    .A1(_0453_),
    .A2(_0455_),
    .ZN(_0456_)
  );
  MUX2_X1 _1039_ (
    .A(\buffer[5] [30]),
    .B(data_i[30]),
    .S(_0456_),
    .Z(_0096_)
  );
  MUX2_X1 _1040_ (
    .A(\buffer[5] [29]),
    .B(data_i[29]),
    .S(_0456_),
    .Z(_0097_)
  );
  MUX2_X1 _1041_ (
    .A(\buffer[5] [28]),
    .B(data_i[28]),
    .S(_0456_),
    .Z(_0098_)
  );
  MUX2_X1 _1042_ (
    .A(\buffer[5] [27]),
    .B(data_i[27]),
    .S(_0456_),
    .Z(_0099_)
  );
  MUX2_X1 _1043_ (
    .A(\buffer[5] [26]),
    .B(data_i[26]),
    .S(_0456_),
    .Z(_0100_)
  );
  MUX2_X1 _1044_ (
    .A(\buffer[5] [25]),
    .B(data_i[25]),
    .S(_0456_),
    .Z(_0101_)
  );
  MUX2_X1 _1045_ (
    .A(\buffer[5] [24]),
    .B(data_i[24]),
    .S(_0456_),
    .Z(_0102_)
  );
  MUX2_X1 _1046_ (
    .A(\buffer[5] [23]),
    .B(data_i[23]),
    .S(_0456_),
    .Z(_0103_)
  );
  MUX2_X1 _1047_ (
    .A(\buffer[5] [22]),
    .B(data_i[22]),
    .S(_0456_),
    .Z(_0104_)
  );
  MUX2_X1 _1048_ (
    .A(\buffer[5] [21]),
    .B(data_i[21]),
    .S(_0456_),
    .Z(_0105_)
  );
  MUX2_X1 _1049_ (
    .A(\buffer[5] [20]),
    .B(data_i[20]),
    .S(_0456_),
    .Z(_0106_)
  );
  MUX2_X1 _1050_ (
    .A(\buffer[5] [19]),
    .B(data_i[19]),
    .S(_0456_),
    .Z(_0107_)
  );
  MUX2_X1 _1051_ (
    .A(\buffer[5] [18]),
    .B(data_i[18]),
    .S(_0456_),
    .Z(_0108_)
  );
  MUX2_X1 _1052_ (
    .A(\buffer[5] [17]),
    .B(data_i[17]),
    .S(_0456_),
    .Z(_0109_)
  );
  MUX2_X1 _1053_ (
    .A(\buffer[5] [16]),
    .B(data_i[16]),
    .S(_0456_),
    .Z(_0110_)
  );
  MUX2_X1 _1054_ (
    .A(\buffer[5] [15]),
    .B(data_i[15]),
    .S(_0456_),
    .Z(_0111_)
  );
  MUX2_X1 _1055_ (
    .A(\buffer[5] [14]),
    .B(data_i[14]),
    .S(_0456_),
    .Z(_0112_)
  );
  MUX2_X1 _1056_ (
    .A(\buffer[5] [13]),
    .B(data_i[13]),
    .S(_0456_),
    .Z(_0113_)
  );
  MUX2_X1 _1057_ (
    .A(\buffer[5] [12]),
    .B(data_i[12]),
    .S(_0456_),
    .Z(_0114_)
  );
  MUX2_X1 _1058_ (
    .A(\buffer[5] [11]),
    .B(data_i[11]),
    .S(_0456_),
    .Z(_0115_)
  );
  MUX2_X1 _1059_ (
    .A(\buffer[5] [10]),
    .B(data_i[10]),
    .S(_0456_),
    .Z(_0116_)
  );
  MUX2_X1 _1060_ (
    .A(\buffer[5] [9]),
    .B(data_i[9]),
    .S(_0456_),
    .Z(_0117_)
  );
  MUX2_X1 _1061_ (
    .A(\buffer[5] [8]),
    .B(data_i[8]),
    .S(_0456_),
    .Z(_0118_)
  );
  MUX2_X1 _1062_ (
    .A(\buffer[5] [7]),
    .B(data_i[7]),
    .S(_0456_),
    .Z(_0119_)
  );
  MUX2_X1 _1063_ (
    .A(\buffer[5] [6]),
    .B(data_i[6]),
    .S(_0456_),
    .Z(_0120_)
  );
  MUX2_X1 _1064_ (
    .A(\buffer[5] [5]),
    .B(data_i[5]),
    .S(_0456_),
    .Z(_0121_)
  );
  MUX2_X1 _1065_ (
    .A(\buffer[5] [4]),
    .B(data_i[4]),
    .S(_0456_),
    .Z(_0122_)
  );
  MUX2_X1 _1066_ (
    .A(\buffer[5] [3]),
    .B(data_i[3]),
    .S(_0456_),
    .Z(_0123_)
  );
  MUX2_X1 _1067_ (
    .A(\buffer[5] [2]),
    .B(data_i[2]),
    .S(_0456_),
    .Z(_0124_)
  );
  MUX2_X1 _1068_ (
    .A(\buffer[5] [1]),
    .B(data_i[1]),
    .S(_0456_),
    .Z(_0125_)
  );
  MUX2_X1 _1069_ (
    .A(\buffer[5] [0]),
    .B(data_i[0]),
    .S(_0456_),
    .Z(_0126_)
  );
  NOR2_X1 _1070_ (
    .A1(_0451_),
    .A2(_0455_),
    .ZN(_0457_)
  );
  MUX2_X1 _1071_ (
    .A(\buffer[6] [30]),
    .B(data_i[30]),
    .S(_0457_),
    .Z(_0127_)
  );
  MUX2_X1 _1072_ (
    .A(\buffer[6] [29]),
    .B(data_i[29]),
    .S(_0457_),
    .Z(_0128_)
  );
  MUX2_X1 _1073_ (
    .A(\buffer[6] [28]),
    .B(data_i[28]),
    .S(_0457_),
    .Z(_0129_)
  );
  MUX2_X1 _1074_ (
    .A(\buffer[6] [27]),
    .B(data_i[27]),
    .S(_0457_),
    .Z(_0130_)
  );
  MUX2_X1 _1075_ (
    .A(\buffer[6] [26]),
    .B(data_i[26]),
    .S(_0457_),
    .Z(_0131_)
  );
  MUX2_X1 _1076_ (
    .A(\buffer[6] [25]),
    .B(data_i[25]),
    .S(_0457_),
    .Z(_0132_)
  );
  MUX2_X1 _1077_ (
    .A(\buffer[6] [24]),
    .B(data_i[24]),
    .S(_0457_),
    .Z(_0133_)
  );
  MUX2_X1 _1078_ (
    .A(\buffer[6] [23]),
    .B(data_i[23]),
    .S(_0457_),
    .Z(_0134_)
  );
  MUX2_X1 _1079_ (
    .A(\buffer[6] [22]),
    .B(data_i[22]),
    .S(_0457_),
    .Z(_0135_)
  );
  MUX2_X1 _1080_ (
    .A(\buffer[6] [21]),
    .B(data_i[21]),
    .S(_0457_),
    .Z(_0136_)
  );
  MUX2_X1 _1081_ (
    .A(\buffer[6] [20]),
    .B(data_i[20]),
    .S(_0457_),
    .Z(_0137_)
  );
  MUX2_X1 _1082_ (
    .A(\buffer[6] [19]),
    .B(data_i[19]),
    .S(_0457_),
    .Z(_0138_)
  );
  MUX2_X1 _1083_ (
    .A(\buffer[6] [18]),
    .B(data_i[18]),
    .S(_0457_),
    .Z(_0139_)
  );
  MUX2_X1 _1084_ (
    .A(\buffer[6] [17]),
    .B(data_i[17]),
    .S(_0457_),
    .Z(_0140_)
  );
  MUX2_X1 _1085_ (
    .A(\buffer[6] [16]),
    .B(data_i[16]),
    .S(_0457_),
    .Z(_0141_)
  );
  MUX2_X1 _1086_ (
    .A(\buffer[6] [15]),
    .B(data_i[15]),
    .S(_0457_),
    .Z(_0142_)
  );
  MUX2_X1 _1087_ (
    .A(\buffer[6] [14]),
    .B(data_i[14]),
    .S(_0457_),
    .Z(_0143_)
  );
  MUX2_X1 _1088_ (
    .A(\buffer[6] [13]),
    .B(data_i[13]),
    .S(_0457_),
    .Z(_0144_)
  );
  MUX2_X1 _1089_ (
    .A(\buffer[6] [12]),
    .B(data_i[12]),
    .S(_0457_),
    .Z(_0145_)
  );
  MUX2_X1 _1090_ (
    .A(\buffer[6] [11]),
    .B(data_i[11]),
    .S(_0457_),
    .Z(_0146_)
  );
  MUX2_X1 _1091_ (
    .A(\buffer[6] [10]),
    .B(data_i[10]),
    .S(_0457_),
    .Z(_0147_)
  );
  MUX2_X1 _1092_ (
    .A(\buffer[6] [9]),
    .B(data_i[9]),
    .S(_0457_),
    .Z(_0148_)
  );
  MUX2_X1 _1093_ (
    .A(\buffer[6] [8]),
    .B(data_i[8]),
    .S(_0457_),
    .Z(_0149_)
  );
  MUX2_X1 _1094_ (
    .A(\buffer[6] [7]),
    .B(data_i[7]),
    .S(_0457_),
    .Z(_0150_)
  );
  MUX2_X1 _1095_ (
    .A(\buffer[6] [6]),
    .B(data_i[6]),
    .S(_0457_),
    .Z(_0151_)
  );
  MUX2_X1 _1096_ (
    .A(\buffer[6] [5]),
    .B(data_i[5]),
    .S(_0457_),
    .Z(_0152_)
  );
  MUX2_X1 _1097_ (
    .A(\buffer[6] [4]),
    .B(data_i[4]),
    .S(_0457_),
    .Z(_0153_)
  );
  MUX2_X1 _1098_ (
    .A(\buffer[6] [3]),
    .B(data_i[3]),
    .S(_0457_),
    .Z(_0154_)
  );
  MUX2_X1 _1099_ (
    .A(\buffer[6] [2]),
    .B(data_i[2]),
    .S(_0457_),
    .Z(_0155_)
  );
  MUX2_X1 _1100_ (
    .A(\buffer[6] [1]),
    .B(data_i[1]),
    .S(_0457_),
    .Z(_0156_)
  );
  MUX2_X1 _1101_ (
    .A(\buffer[6] [0]),
    .B(data_i[0]),
    .S(_0457_),
    .Z(_0157_)
  );
  NOR4_X1 _1102_ (
    .A1(_0283_),
    .A2(_0284_),
    .A3(pointer_in[2]),
    .A4(_0413_),
    .ZN(_0458_)
  );
  MUX2_X1 _1103_ (
    .A(\buffer[3] [30]),
    .B(data_i[30]),
    .S(_0458_),
    .Z(_0158_)
  );
  MUX2_X1 _1104_ (
    .A(\buffer[3] [29]),
    .B(data_i[29]),
    .S(_0458_),
    .Z(_0159_)
  );
  MUX2_X1 _1105_ (
    .A(\buffer[3] [28]),
    .B(data_i[28]),
    .S(_0458_),
    .Z(_0160_)
  );
  MUX2_X1 _1106_ (
    .A(\buffer[3] [27]),
    .B(data_i[27]),
    .S(_0458_),
    .Z(_0161_)
  );
  MUX2_X1 _1107_ (
    .A(\buffer[3] [26]),
    .B(data_i[26]),
    .S(_0458_),
    .Z(_0162_)
  );
  MUX2_X1 _1108_ (
    .A(\buffer[3] [25]),
    .B(data_i[25]),
    .S(_0458_),
    .Z(_0163_)
  );
  MUX2_X1 _1109_ (
    .A(\buffer[3] [24]),
    .B(data_i[24]),
    .S(_0458_),
    .Z(_0164_)
  );
  MUX2_X1 _1110_ (
    .A(\buffer[3] [23]),
    .B(data_i[23]),
    .S(_0458_),
    .Z(_0165_)
  );
  MUX2_X1 _1111_ (
    .A(\buffer[3] [22]),
    .B(data_i[22]),
    .S(_0458_),
    .Z(_0166_)
  );
  MUX2_X1 _1112_ (
    .A(\buffer[3] [21]),
    .B(data_i[21]),
    .S(_0458_),
    .Z(_0167_)
  );
  MUX2_X1 _1113_ (
    .A(\buffer[3] [20]),
    .B(data_i[20]),
    .S(_0458_),
    .Z(_0168_)
  );
  MUX2_X1 _1114_ (
    .A(\buffer[3] [19]),
    .B(data_i[19]),
    .S(_0458_),
    .Z(_0169_)
  );
  MUX2_X1 _1115_ (
    .A(\buffer[3] [18]),
    .B(data_i[18]),
    .S(_0458_),
    .Z(_0170_)
  );
  MUX2_X1 _1116_ (
    .A(\buffer[3] [17]),
    .B(data_i[17]),
    .S(_0458_),
    .Z(_0171_)
  );
  MUX2_X1 _1117_ (
    .A(\buffer[3] [16]),
    .B(data_i[16]),
    .S(_0458_),
    .Z(_0172_)
  );
  MUX2_X1 _1118_ (
    .A(\buffer[3] [15]),
    .B(data_i[15]),
    .S(_0458_),
    .Z(_0173_)
  );
  MUX2_X1 _1119_ (
    .A(\buffer[3] [14]),
    .B(data_i[14]),
    .S(_0458_),
    .Z(_0174_)
  );
  MUX2_X1 _1120_ (
    .A(\buffer[3] [13]),
    .B(data_i[13]),
    .S(_0458_),
    .Z(_0175_)
  );
  MUX2_X1 _1121_ (
    .A(\buffer[3] [12]),
    .B(data_i[12]),
    .S(_0458_),
    .Z(_0176_)
  );
  MUX2_X1 _1122_ (
    .A(\buffer[3] [11]),
    .B(data_i[11]),
    .S(_0458_),
    .Z(_0177_)
  );
  MUX2_X1 _1123_ (
    .A(\buffer[3] [10]),
    .B(data_i[10]),
    .S(_0458_),
    .Z(_0178_)
  );
  MUX2_X1 _1124_ (
    .A(\buffer[3] [9]),
    .B(data_i[9]),
    .S(_0458_),
    .Z(_0179_)
  );
  MUX2_X1 _1125_ (
    .A(\buffer[3] [8]),
    .B(data_i[8]),
    .S(_0458_),
    .Z(_0180_)
  );
  MUX2_X1 _1126_ (
    .A(\buffer[3] [7]),
    .B(data_i[7]),
    .S(_0458_),
    .Z(_0181_)
  );
  MUX2_X1 _1127_ (
    .A(\buffer[3] [6]),
    .B(data_i[6]),
    .S(_0458_),
    .Z(_0182_)
  );
  MUX2_X1 _1128_ (
    .A(\buffer[3] [5]),
    .B(data_i[5]),
    .S(_0458_),
    .Z(_0183_)
  );
  MUX2_X1 _1129_ (
    .A(\buffer[3] [4]),
    .B(data_i[4]),
    .S(_0458_),
    .Z(_0184_)
  );
  MUX2_X1 _1130_ (
    .A(\buffer[3] [3]),
    .B(data_i[3]),
    .S(_0458_),
    .Z(_0185_)
  );
  MUX2_X1 _1131_ (
    .A(\buffer[3] [2]),
    .B(data_i[2]),
    .S(_0458_),
    .Z(_0186_)
  );
  MUX2_X1 _1132_ (
    .A(\buffer[3] [1]),
    .B(data_i[1]),
    .S(_0458_),
    .Z(_0187_)
  );
  MUX2_X1 _1133_ (
    .A(\buffer[3] [0]),
    .B(data_i[0]),
    .S(_0458_),
    .Z(_0188_)
  );
  MUX2_X1 _1134_ (
    .A(\buffer[0] [29]),
    .B(data_i[29]),
    .S(_0443_),
    .Z(_0189_)
  );
  MUX2_X1 _1135_ (
    .A(\buffer[0] [28]),
    .B(data_i[28]),
    .S(_0443_),
    .Z(_0190_)
  );
  MUX2_X1 _1136_ (
    .A(\buffer[0] [27]),
    .B(data_i[27]),
    .S(_0443_),
    .Z(_0191_)
  );
  MUX2_X1 _1137_ (
    .A(\buffer[0] [26]),
    .B(data_i[26]),
    .S(_0443_),
    .Z(_0192_)
  );
  MUX2_X1 _1138_ (
    .A(\buffer[0] [25]),
    .B(data_i[25]),
    .S(_0443_),
    .Z(_0193_)
  );
  MUX2_X1 _1139_ (
    .A(\buffer[0] [24]),
    .B(data_i[24]),
    .S(_0443_),
    .Z(_0194_)
  );
  MUX2_X1 _1140_ (
    .A(\buffer[0] [23]),
    .B(data_i[23]),
    .S(_0443_),
    .Z(_0195_)
  );
  MUX2_X1 _1141_ (
    .A(\buffer[0] [22]),
    .B(data_i[22]),
    .S(_0443_),
    .Z(_0196_)
  );
  MUX2_X1 _1142_ (
    .A(\buffer[0] [21]),
    .B(data_i[21]),
    .S(_0443_),
    .Z(_0197_)
  );
  MUX2_X1 _1143_ (
    .A(\buffer[0] [20]),
    .B(data_i[20]),
    .S(_0443_),
    .Z(_0198_)
  );
  MUX2_X1 _1144_ (
    .A(\buffer[0] [19]),
    .B(data_i[19]),
    .S(_0443_),
    .Z(_0199_)
  );
  MUX2_X1 _1145_ (
    .A(\buffer[0] [18]),
    .B(data_i[18]),
    .S(_0443_),
    .Z(_0200_)
  );
  MUX2_X1 _1146_ (
    .A(\buffer[0] [17]),
    .B(data_i[17]),
    .S(_0443_),
    .Z(_0201_)
  );
  MUX2_X1 _1147_ (
    .A(\buffer[0] [16]),
    .B(data_i[16]),
    .S(_0443_),
    .Z(_0202_)
  );
  MUX2_X1 _1148_ (
    .A(\buffer[0] [15]),
    .B(data_i[15]),
    .S(_0443_),
    .Z(_0203_)
  );
  MUX2_X1 _1149_ (
    .A(\buffer[0] [14]),
    .B(data_i[14]),
    .S(_0443_),
    .Z(_0204_)
  );
  MUX2_X1 _1150_ (
    .A(\buffer[0] [13]),
    .B(data_i[13]),
    .S(_0443_),
    .Z(_0205_)
  );
  MUX2_X1 _1151_ (
    .A(\buffer[0] [12]),
    .B(data_i[12]),
    .S(_0443_),
    .Z(_0206_)
  );
  MUX2_X1 _1152_ (
    .A(\buffer[0] [11]),
    .B(data_i[11]),
    .S(_0443_),
    .Z(_0207_)
  );
  MUX2_X1 _1153_ (
    .A(\buffer[3] [31]),
    .B(data_i[31]),
    .S(_0458_),
    .Z(_0208_)
  );
  MUX2_X1 _1154_ (
    .A(\buffer[0] [10]),
    .B(data_i[10]),
    .S(_0443_),
    .Z(_0209_)
  );
  MUX2_X1 _1155_ (
    .A(\buffer[0] [9]),
    .B(data_i[9]),
    .S(_0443_),
    .Z(_0210_)
  );
  MUX2_X1 _1156_ (
    .A(\buffer[0] [8]),
    .B(data_i[8]),
    .S(_0443_),
    .Z(_0211_)
  );
  MUX2_X1 _1157_ (
    .A(\buffer[0] [7]),
    .B(data_i[7]),
    .S(_0443_),
    .Z(_0212_)
  );
  MUX2_X1 _1158_ (
    .A(\buffer[0] [6]),
    .B(data_i[6]),
    .S(_0443_),
    .Z(_0213_)
  );
  MUX2_X1 _1159_ (
    .A(\buffer[0] [5]),
    .B(data_i[5]),
    .S(_0443_),
    .Z(_0214_)
  );
  MUX2_X1 _1160_ (
    .A(\buffer[0] [4]),
    .B(data_i[4]),
    .S(_0443_),
    .Z(_0215_)
  );
  MUX2_X1 _1161_ (
    .A(\buffer[0] [3]),
    .B(data_i[3]),
    .S(_0443_),
    .Z(_0216_)
  );
  MUX2_X1 _1162_ (
    .A(\buffer[0] [2]),
    .B(data_i[2]),
    .S(_0443_),
    .Z(_0217_)
  );
  MUX2_X1 _1163_ (
    .A(\buffer[0] [1]),
    .B(data_i[1]),
    .S(_0443_),
    .Z(_0218_)
  );
  MUX2_X1 _1164_ (
    .A(\buffer[0] [0]),
    .B(data_i[0]),
    .S(_0443_),
    .Z(_0219_)
  );
  NOR3_X1 _1165_ (
    .A1(pointer_in[1]),
    .A2(pointer_in[0]),
    .A3(_0455_),
    .ZN(_0268_)
  );
  MUX2_X1 _1166_ (
    .A(\buffer[4] [30]),
    .B(data_i[30]),
    .S(_0268_),
    .Z(_0220_)
  );
  MUX2_X1 _1167_ (
    .A(\buffer[4] [29]),
    .B(data_i[29]),
    .S(_0268_),
    .Z(_0221_)
  );
  MUX2_X1 _1168_ (
    .A(\buffer[4] [28]),
    .B(data_i[28]),
    .S(_0268_),
    .Z(_0222_)
  );
  MUX2_X1 _1169_ (
    .A(\buffer[4] [27]),
    .B(data_i[27]),
    .S(_0268_),
    .Z(_0223_)
  );
  MUX2_X1 _1170_ (
    .A(\buffer[4] [26]),
    .B(data_i[26]),
    .S(_0268_),
    .Z(_0224_)
  );
  MUX2_X1 _1171_ (
    .A(\buffer[4] [25]),
    .B(data_i[25]),
    .S(_0268_),
    .Z(_0225_)
  );
  MUX2_X1 _1172_ (
    .A(\buffer[5] [31]),
    .B(data_i[31]),
    .S(_0456_),
    .Z(_0226_)
  );
  MUX2_X1 _1173_ (
    .A(\buffer[1] [31]),
    .B(data_i[31]),
    .S(_0454_),
    .Z(_0227_)
  );
  MUX2_X1 _1174_ (
    .A(\buffer[4] [24]),
    .B(data_i[24]),
    .S(_0268_),
    .Z(_0228_)
  );
  MUX2_X1 _1175_ (
    .A(\buffer[6] [31]),
    .B(data_i[31]),
    .S(_0457_),
    .Z(_0229_)
  );
  MUX2_X1 _1176_ (
    .A(\buffer[4] [23]),
    .B(data_i[23]),
    .S(_0268_),
    .Z(_0230_)
  );
  MUX2_X1 _1177_ (
    .A(\buffer[4] [22]),
    .B(data_i[22]),
    .S(_0268_),
    .Z(_0231_)
  );
  MUX2_X1 _1178_ (
    .A(\buffer[4] [21]),
    .B(data_i[21]),
    .S(_0268_),
    .Z(_0232_)
  );
  MUX2_X1 _1179_ (
    .A(\buffer[4] [20]),
    .B(data_i[20]),
    .S(_0268_),
    .Z(_0233_)
  );
  MUX2_X1 _1180_ (
    .A(\buffer[4] [19]),
    .B(data_i[19]),
    .S(_0268_),
    .Z(_0234_)
  );
  MUX2_X1 _1181_ (
    .A(\buffer[4] [18]),
    .B(data_i[18]),
    .S(_0268_),
    .Z(_0235_)
  );
  MUX2_X1 _1182_ (
    .A(\buffer[4] [17]),
    .B(data_i[17]),
    .S(_0268_),
    .Z(_0236_)
  );
  MUX2_X1 _1183_ (
    .A(\buffer[4] [16]),
    .B(data_i[16]),
    .S(_0268_),
    .Z(_0237_)
  );
  MUX2_X1 _1184_ (
    .A(\buffer[4] [15]),
    .B(data_i[15]),
    .S(_0268_),
    .Z(_0238_)
  );
  MUX2_X1 _1185_ (
    .A(\buffer[4] [14]),
    .B(data_i[14]),
    .S(_0268_),
    .Z(_0239_)
  );
  MUX2_X1 _1186_ (
    .A(\buffer[4] [13]),
    .B(data_i[13]),
    .S(_0268_),
    .Z(_0240_)
  );
  MUX2_X1 _1187_ (
    .A(\buffer[4] [12]),
    .B(data_i[12]),
    .S(_0268_),
    .Z(_0241_)
  );
  MUX2_X1 _1188_ (
    .A(\buffer[4] [11]),
    .B(data_i[11]),
    .S(_0268_),
    .Z(_0242_)
  );
  MUX2_X1 _1189_ (
    .A(\buffer[4] [10]),
    .B(data_i[10]),
    .S(_0268_),
    .Z(_0243_)
  );
  MUX2_X1 _1190_ (
    .A(\buffer[4] [9]),
    .B(data_i[9]),
    .S(_0268_),
    .Z(_0244_)
  );
  MUX2_X1 _1191_ (
    .A(\buffer[4] [8]),
    .B(data_i[8]),
    .S(_0268_),
    .Z(_0245_)
  );
  MUX2_X1 _1192_ (
    .A(\buffer[4] [7]),
    .B(data_i[7]),
    .S(_0268_),
    .Z(_0246_)
  );
  MUX2_X1 _1193_ (
    .A(\buffer[4] [6]),
    .B(data_i[6]),
    .S(_0268_),
    .Z(_0247_)
  );
  MUX2_X1 _1194_ (
    .A(\buffer[4] [5]),
    .B(data_i[5]),
    .S(_0268_),
    .Z(_0248_)
  );
  MUX2_X1 _1195_ (
    .A(\buffer[4] [4]),
    .B(data_i[4]),
    .S(_0268_),
    .Z(_0249_)
  );
  MUX2_X1 _1196_ (
    .A(\buffer[4] [3]),
    .B(data_i[3]),
    .S(_0268_),
    .Z(_0250_)
  );
  MUX2_X1 _1197_ (
    .A(\buffer[4] [2]),
    .B(data_i[2]),
    .S(_0268_),
    .Z(_0251_)
  );
  MUX2_X1 _1198_ (
    .A(\buffer[2] [31]),
    .B(data_i[31]),
    .S(_0452_),
    .Z(_0252_)
  );
  OAI21_X1 _1199_ (
    .A(_0422_),
    .B1(_0419_),
    .B2(_0278_),
    .ZN(_0269_)
  );
  AOI221_X1 _1200_ (
    .A(_0269_),
    .B1(_0433_),
    .B2(_0419_),
    .C1(_0278_),
    .C2(_0434_),
    .ZN(_0270_)
  );
  OAI21_X1 _1201_ (
    .A(_0282_),
    .B1(_0270_),
    .B2(elements[4]),
    .ZN(_0271_)
  );
  AOI21_X1 _1202_ (
    .A(_0271_),
    .B1(_0270_),
    .B2(elements[4]),
    .ZN(_0253_)
  );
  MUX2_X1 _1203_ (
    .A(\buffer[4] [1]),
    .B(data_i[1]),
    .S(_0268_),
    .Z(_0254_)
  );
  MUX2_X1 _1204_ (
    .A(\buffer[4] [0]),
    .B(data_i[0]),
    .S(_0268_),
    .Z(_0255_)
  );
  MUX2_X1 _1205_ (
    .A(data_i[31]),
    .B(\buffer[7] [31]),
    .S(_0415_),
    .Z(_0256_)
  );
  MUX2_X1 _1206_ (
    .A(data_i[30]),
    .B(\buffer[7] [30]),
    .S(_0415_),
    .Z(_0257_)
  );
  MUX2_X1 _1207_ (
    .A(data_i[29]),
    .B(\buffer[7] [29]),
    .S(_0415_),
    .Z(_0258_)
  );
  MUX2_X1 _1208_ (
    .A(data_i[28]),
    .B(\buffer[7] [28]),
    .S(_0415_),
    .Z(_0259_)
  );
  MUX2_X1 _1209_ (
    .A(data_i[27]),
    .B(\buffer[7] [27]),
    .S(_0415_),
    .Z(_0260_)
  );
  MUX2_X1 _1210_ (
    .A(data_i[26]),
    .B(\buffer[7] [26]),
    .S(_0415_),
    .Z(_0261_)
  );
  MUX2_X1 _1211_ (
    .A(data_i[25]),
    .B(\buffer[7] [25]),
    .S(_0415_),
    .Z(_0262_)
  );
  MUX2_X1 _1212_ (
    .A(data_i[24]),
    .B(\buffer[7] [24]),
    .S(_0415_),
    .Z(_0263_)
  );
  MUX2_X1 _1213_ (
    .A(data_i[23]),
    .B(\buffer[7] [23]),
    .S(_0415_),
    .Z(_0264_)
  );
  MUX2_X1 _1214_ (
    .A(\buffer[4] [31]),
    .B(data_i[31]),
    .S(_0268_),
    .Z(_0265_)
  );
  MUX2_X1 _1215_ (
    .A(\buffer[0] [31]),
    .B(data_i[31]),
    .S(_0443_),
    .Z(_0266_)
  );
  MUX2_X1 _1216_ (
    .A(data_i[22]),
    .B(\buffer[7] [22]),
    .S(_0415_),
    .Z(_0267_)
  );
  DFFR_X1 _1217_ (
    .CK(clk_i),
    .D(_0188_),
    .Q(\buffer[3] [0]),
    .QN(_0538_),
    .RN(rst_ni)
  );
  DFFR_X1 _1218_ (
    .CK(clk_i),
    .D(_0187_),
    .Q(\buffer[3] [1]),
    .QN(_0539_),
    .RN(rst_ni)
  );
  DFFR_X1 _1219_ (
    .CK(clk_i),
    .D(_0186_),
    .Q(\buffer[3] [2]),
    .QN(_0540_),
    .RN(rst_ni)
  );
  DFFR_X1 _1220_ (
    .CK(clk_i),
    .D(_0185_),
    .Q(\buffer[3] [3]),
    .QN(_0541_),
    .RN(rst_ni)
  );
  DFFR_X1 _1221_ (
    .CK(clk_i),
    .D(_0184_),
    .Q(\buffer[3] [4]),
    .QN(_0542_),
    .RN(rst_ni)
  );
  DFFR_X1 _1222_ (
    .CK(clk_i),
    .D(_0183_),
    .Q(\buffer[3] [5]),
    .QN(_0543_),
    .RN(rst_ni)
  );
  DFFR_X1 _1223_ (
    .CK(clk_i),
    .D(_0182_),
    .Q(\buffer[3] [6]),
    .QN(_0544_),
    .RN(rst_ni)
  );
  DFFR_X1 _1224_ (
    .CK(clk_i),
    .D(_0181_),
    .Q(\buffer[3] [7]),
    .QN(_0545_),
    .RN(rst_ni)
  );
  DFFR_X1 _1225_ (
    .CK(clk_i),
    .D(_0180_),
    .Q(\buffer[3] [8]),
    .QN(_0546_),
    .RN(rst_ni)
  );
  DFFR_X1 _1226_ (
    .CK(clk_i),
    .D(_0179_),
    .Q(\buffer[3] [9]),
    .QN(_0547_),
    .RN(rst_ni)
  );
  DFFR_X1 _1227_ (
    .CK(clk_i),
    .D(_0178_),
    .Q(\buffer[3] [10]),
    .QN(_0548_),
    .RN(rst_ni)
  );
  DFFR_X1 _1228_ (
    .CK(clk_i),
    .D(_0177_),
    .Q(\buffer[3] [11]),
    .QN(_0549_),
    .RN(rst_ni)
  );
  DFFR_X1 _1229_ (
    .CK(clk_i),
    .D(_0176_),
    .Q(\buffer[3] [12]),
    .QN(_0550_),
    .RN(rst_ni)
  );
  DFFR_X1 _1230_ (
    .CK(clk_i),
    .D(_0175_),
    .Q(\buffer[3] [13]),
    .QN(_0551_),
    .RN(rst_ni)
  );
  DFFR_X1 _1231_ (
    .CK(clk_i),
    .D(_0174_),
    .Q(\buffer[3] [14]),
    .QN(_0552_),
    .RN(rst_ni)
  );
  DFFR_X1 _1232_ (
    .CK(clk_i),
    .D(_0173_),
    .Q(\buffer[3] [15]),
    .QN(_0553_),
    .RN(rst_ni)
  );
  DFFR_X1 _1233_ (
    .CK(clk_i),
    .D(_0172_),
    .Q(\buffer[3] [16]),
    .QN(_0554_),
    .RN(rst_ni)
  );
  DFFR_X1 _1234_ (
    .CK(clk_i),
    .D(_0171_),
    .Q(\buffer[3] [17]),
    .QN(_0555_),
    .RN(rst_ni)
  );
  DFFR_X1 _1235_ (
    .CK(clk_i),
    .D(_0170_),
    .Q(\buffer[3] [18]),
    .QN(_0556_),
    .RN(rst_ni)
  );
  DFFR_X1 _1236_ (
    .CK(clk_i),
    .D(_0169_),
    .Q(\buffer[3] [19]),
    .QN(_0557_),
    .RN(rst_ni)
  );
  DFFR_X1 _1237_ (
    .CK(clk_i),
    .D(_0168_),
    .Q(\buffer[3] [20]),
    .QN(_0558_),
    .RN(rst_ni)
  );
  DFFR_X1 _1238_ (
    .CK(clk_i),
    .D(_0167_),
    .Q(\buffer[3] [21]),
    .QN(_0559_),
    .RN(rst_ni)
  );
  DFFR_X1 _1239_ (
    .CK(clk_i),
    .D(_0166_),
    .Q(\buffer[3] [22]),
    .QN(_0560_),
    .RN(rst_ni)
  );
  DFFR_X1 _1240_ (
    .CK(clk_i),
    .D(_0165_),
    .Q(\buffer[3] [23]),
    .QN(_0561_),
    .RN(rst_ni)
  );
  DFFR_X1 _1241_ (
    .CK(clk_i),
    .D(_0164_),
    .Q(\buffer[3] [24]),
    .QN(_0562_),
    .RN(rst_ni)
  );
  DFFR_X1 _1242_ (
    .CK(clk_i),
    .D(_0163_),
    .Q(\buffer[3] [25]),
    .QN(_0563_),
    .RN(rst_ni)
  );
  DFFR_X1 _1243_ (
    .CK(clk_i),
    .D(_0162_),
    .Q(\buffer[3] [26]),
    .QN(_0564_),
    .RN(rst_ni)
  );
  DFFR_X1 _1244_ (
    .CK(clk_i),
    .D(_0161_),
    .Q(\buffer[3] [27]),
    .QN(_0565_),
    .RN(rst_ni)
  );
  DFFR_X1 _1245_ (
    .CK(clk_i),
    .D(_0160_),
    .Q(\buffer[3] [28]),
    .QN(_0566_),
    .RN(rst_ni)
  );
  DFFR_X1 _1246_ (
    .CK(clk_i),
    .D(_0159_),
    .Q(\buffer[3] [29]),
    .QN(_0567_),
    .RN(rst_ni)
  );
  DFFR_X1 _1247_ (
    .CK(clk_i),
    .D(_0158_),
    .Q(\buffer[3] [30]),
    .QN(_0568_),
    .RN(rst_ni)
  );
  DFFR_X1 _1248_ (
    .CK(clk_i),
    .D(_0208_),
    .Q(\buffer[3] [31]),
    .QN(_0518_),
    .RN(rst_ni)
  );
  DFFR_X1 _1249_ (
    .CK(clk_i),
    .D(_0157_),
    .Q(\buffer[6] [0]),
    .QN(_0569_),
    .RN(rst_ni)
  );
  DFFR_X1 _1250_ (
    .CK(clk_i),
    .D(_0156_),
    .Q(\buffer[6] [1]),
    .QN(_0570_),
    .RN(rst_ni)
  );
  DFFR_X1 _1251_ (
    .CK(clk_i),
    .D(_0155_),
    .Q(\buffer[6] [2]),
    .QN(_0571_),
    .RN(rst_ni)
  );
  DFFR_X1 _1252_ (
    .CK(clk_i),
    .D(_0154_),
    .Q(\buffer[6] [3]),
    .QN(_0572_),
    .RN(rst_ni)
  );
  DFFR_X1 _1253_ (
    .CK(clk_i),
    .D(_0153_),
    .Q(\buffer[6] [4]),
    .QN(_0573_),
    .RN(rst_ni)
  );
  DFFR_X1 _1254_ (
    .CK(clk_i),
    .D(_0152_),
    .Q(\buffer[6] [5]),
    .QN(_0574_),
    .RN(rst_ni)
  );
  DFFR_X1 _1255_ (
    .CK(clk_i),
    .D(_0151_),
    .Q(\buffer[6] [6]),
    .QN(_0575_),
    .RN(rst_ni)
  );
  DFFR_X1 _1256_ (
    .CK(clk_i),
    .D(_0150_),
    .Q(\buffer[6] [7]),
    .QN(_0576_),
    .RN(rst_ni)
  );
  DFFR_X1 _1257_ (
    .CK(clk_i),
    .D(_0149_),
    .Q(\buffer[6] [8]),
    .QN(_0577_),
    .RN(rst_ni)
  );
  DFFR_X1 _1258_ (
    .CK(clk_i),
    .D(_0148_),
    .Q(\buffer[6] [9]),
    .QN(_0578_),
    .RN(rst_ni)
  );
  DFFR_X1 _1259_ (
    .CK(clk_i),
    .D(_0147_),
    .Q(\buffer[6] [10]),
    .QN(_0579_),
    .RN(rst_ni)
  );
  DFFR_X1 _1260_ (
    .CK(clk_i),
    .D(_0146_),
    .Q(\buffer[6] [11]),
    .QN(_0580_),
    .RN(rst_ni)
  );
  DFFR_X1 _1261_ (
    .CK(clk_i),
    .D(_0145_),
    .Q(\buffer[6] [12]),
    .QN(_0581_),
    .RN(rst_ni)
  );
  DFFR_X1 _1262_ (
    .CK(clk_i),
    .D(_0144_),
    .Q(\buffer[6] [13]),
    .QN(_0582_),
    .RN(rst_ni)
  );
  DFFR_X1 _1263_ (
    .CK(clk_i),
    .D(_0143_),
    .Q(\buffer[6] [14]),
    .QN(_0583_),
    .RN(rst_ni)
  );
  DFFR_X1 _1264_ (
    .CK(clk_i),
    .D(_0142_),
    .Q(\buffer[6] [15]),
    .QN(_0584_),
    .RN(rst_ni)
  );
  DFFR_X1 _1265_ (
    .CK(clk_i),
    .D(_0141_),
    .Q(\buffer[6] [16]),
    .QN(_0585_),
    .RN(rst_ni)
  );
  DFFR_X1 _1266_ (
    .CK(clk_i),
    .D(_0140_),
    .Q(\buffer[6] [17]),
    .QN(_0586_),
    .RN(rst_ni)
  );
  DFFR_X1 _1267_ (
    .CK(clk_i),
    .D(_0139_),
    .Q(\buffer[6] [18]),
    .QN(_0587_),
    .RN(rst_ni)
  );
  DFFR_X1 _1268_ (
    .CK(clk_i),
    .D(_0138_),
    .Q(\buffer[6] [19]),
    .QN(_0588_),
    .RN(rst_ni)
  );
  DFFR_X1 _1269_ (
    .CK(clk_i),
    .D(_0137_),
    .Q(\buffer[6] [20]),
    .QN(_0589_),
    .RN(rst_ni)
  );
  DFFR_X1 _1270_ (
    .CK(clk_i),
    .D(_0136_),
    .Q(\buffer[6] [21]),
    .QN(_0590_),
    .RN(rst_ni)
  );
  DFFR_X1 _1271_ (
    .CK(clk_i),
    .D(_0135_),
    .Q(\buffer[6] [22]),
    .QN(_0591_),
    .RN(rst_ni)
  );
  DFFR_X1 _1272_ (
    .CK(clk_i),
    .D(_0134_),
    .Q(\buffer[6] [23]),
    .QN(_0592_),
    .RN(rst_ni)
  );
  DFFR_X1 _1273_ (
    .CK(clk_i),
    .D(_0133_),
    .Q(\buffer[6] [24]),
    .QN(_0593_),
    .RN(rst_ni)
  );
  DFFR_X1 _1274_ (
    .CK(clk_i),
    .D(_0132_),
    .Q(\buffer[6] [25]),
    .QN(_0594_),
    .RN(rst_ni)
  );
  DFFR_X1 _1275_ (
    .CK(clk_i),
    .D(_0131_),
    .Q(\buffer[6] [26]),
    .QN(_0595_),
    .RN(rst_ni)
  );
  DFFR_X1 _1276_ (
    .CK(clk_i),
    .D(_0130_),
    .Q(\buffer[6] [27]),
    .QN(_0596_),
    .RN(rst_ni)
  );
  DFFR_X1 _1277_ (
    .CK(clk_i),
    .D(_0129_),
    .Q(\buffer[6] [28]),
    .QN(_0597_),
    .RN(rst_ni)
  );
  DFFR_X1 _1278_ (
    .CK(clk_i),
    .D(_0128_),
    .Q(\buffer[6] [29]),
    .QN(_0598_),
    .RN(rst_ni)
  );
  DFFR_X1 _1279_ (
    .CK(clk_i),
    .D(_0127_),
    .Q(\buffer[6] [30]),
    .QN(_0599_),
    .RN(rst_ni)
  );
  DFFR_X1 _1280_ (
    .CK(clk_i),
    .D(_0229_),
    .Q(\buffer[6] [31]),
    .QN(_0497_),
    .RN(rst_ni)
  );
  DFFR_X1 _1281_ (
    .CK(clk_i),
    .D(_0126_),
    .Q(\buffer[5] [0]),
    .QN(_0600_),
    .RN(rst_ni)
  );
  DFFR_X1 _1282_ (
    .CK(clk_i),
    .D(_0125_),
    .Q(\buffer[5] [1]),
    .QN(_0601_),
    .RN(rst_ni)
  );
  DFFR_X1 _1283_ (
    .CK(clk_i),
    .D(_0124_),
    .Q(\buffer[5] [2]),
    .QN(_0602_),
    .RN(rst_ni)
  );
  DFFR_X1 _1284_ (
    .CK(clk_i),
    .D(_0123_),
    .Q(\buffer[5] [3]),
    .QN(_0603_),
    .RN(rst_ni)
  );
  DFFR_X1 _1285_ (
    .CK(clk_i),
    .D(_0122_),
    .Q(\buffer[5] [4]),
    .QN(_0604_),
    .RN(rst_ni)
  );
  DFFR_X1 _1286_ (
    .CK(clk_i),
    .D(_0121_),
    .Q(\buffer[5] [5]),
    .QN(_0605_),
    .RN(rst_ni)
  );
  DFFR_X1 _1287_ (
    .CK(clk_i),
    .D(_0120_),
    .Q(\buffer[5] [6]),
    .QN(_0606_),
    .RN(rst_ni)
  );
  DFFR_X1 _1288_ (
    .CK(clk_i),
    .D(_0119_),
    .Q(\buffer[5] [7]),
    .QN(_0607_),
    .RN(rst_ni)
  );
  DFFR_X1 _1289_ (
    .CK(clk_i),
    .D(_0118_),
    .Q(\buffer[5] [8]),
    .QN(_0608_),
    .RN(rst_ni)
  );
  DFFR_X1 _1290_ (
    .CK(clk_i),
    .D(_0117_),
    .Q(\buffer[5] [9]),
    .QN(_0609_),
    .RN(rst_ni)
  );
  DFFR_X1 _1291_ (
    .CK(clk_i),
    .D(_0116_),
    .Q(\buffer[5] [10]),
    .QN(_0610_),
    .RN(rst_ni)
  );
  DFFR_X1 _1292_ (
    .CK(clk_i),
    .D(_0115_),
    .Q(\buffer[5] [11]),
    .QN(_0611_),
    .RN(rst_ni)
  );
  DFFR_X1 _1293_ (
    .CK(clk_i),
    .D(_0114_),
    .Q(\buffer[5] [12]),
    .QN(_0612_),
    .RN(rst_ni)
  );
  DFFR_X1 _1294_ (
    .CK(clk_i),
    .D(_0113_),
    .Q(\buffer[5] [13]),
    .QN(_0613_),
    .RN(rst_ni)
  );
  DFFR_X1 _1295_ (
    .CK(clk_i),
    .D(_0112_),
    .Q(\buffer[5] [14]),
    .QN(_0614_),
    .RN(rst_ni)
  );
  DFFR_X1 _1296_ (
    .CK(clk_i),
    .D(_0111_),
    .Q(\buffer[5] [15]),
    .QN(_0615_),
    .RN(rst_ni)
  );
  DFFR_X1 _1297_ (
    .CK(clk_i),
    .D(_0110_),
    .Q(\buffer[5] [16]),
    .QN(_0616_),
    .RN(rst_ni)
  );
  DFFR_X1 _1298_ (
    .CK(clk_i),
    .D(_0109_),
    .Q(\buffer[5] [17]),
    .QN(_0617_),
    .RN(rst_ni)
  );
  DFFR_X1 _1299_ (
    .CK(clk_i),
    .D(_0108_),
    .Q(\buffer[5] [18]),
    .QN(_0618_),
    .RN(rst_ni)
  );
  DFFR_X1 _1300_ (
    .CK(clk_i),
    .D(_0107_),
    .Q(\buffer[5] [19]),
    .QN(_0619_),
    .RN(rst_ni)
  );
  DFFR_X1 _1301_ (
    .CK(clk_i),
    .D(_0106_),
    .Q(\buffer[5] [20]),
    .QN(_0620_),
    .RN(rst_ni)
  );
  DFFR_X1 _1302_ (
    .CK(clk_i),
    .D(_0105_),
    .Q(\buffer[5] [21]),
    .QN(_0621_),
    .RN(rst_ni)
  );
  DFFR_X1 _1303_ (
    .CK(clk_i),
    .D(_0104_),
    .Q(\buffer[5] [22]),
    .QN(_0622_),
    .RN(rst_ni)
  );
  DFFR_X1 _1304_ (
    .CK(clk_i),
    .D(_0103_),
    .Q(\buffer[5] [23]),
    .QN(_0623_),
    .RN(rst_ni)
  );
  DFFR_X1 _1305_ (
    .CK(clk_i),
    .D(_0102_),
    .Q(\buffer[5] [24]),
    .QN(_0624_),
    .RN(rst_ni)
  );
  DFFR_X1 _1306_ (
    .CK(clk_i),
    .D(_0101_),
    .Q(\buffer[5] [25]),
    .QN(_0625_),
    .RN(rst_ni)
  );
  DFFR_X1 _1307_ (
    .CK(clk_i),
    .D(_0100_),
    .Q(\buffer[5] [26]),
    .QN(_0626_),
    .RN(rst_ni)
  );
  DFFR_X1 _1308_ (
    .CK(clk_i),
    .D(_0099_),
    .Q(\buffer[5] [27]),
    .QN(_0627_),
    .RN(rst_ni)
  );
  DFFR_X1 _1309_ (
    .CK(clk_i),
    .D(_0098_),
    .Q(\buffer[5] [28]),
    .QN(_0628_),
    .RN(rst_ni)
  );
  DFFR_X1 _1310_ (
    .CK(clk_i),
    .D(_0097_),
    .Q(\buffer[5] [29]),
    .QN(_0629_),
    .RN(rst_ni)
  );
  DFFR_X1 _1311_ (
    .CK(clk_i),
    .D(_0096_),
    .Q(\buffer[5] [30]),
    .QN(_0630_),
    .RN(rst_ni)
  );
  DFFR_X1 _1312_ (
    .CK(clk_i),
    .D(_0226_),
    .Q(\buffer[5] [31]),
    .QN(_0500_),
    .RN(rst_ni)
  );
  DFFR_X1 _1313_ (
    .CK(clk_i),
    .D(_0095_),
    .Q(\buffer[1] [0]),
    .QN(_0631_),
    .RN(rst_ni)
  );
  DFFR_X1 _1314_ (
    .CK(clk_i),
    .D(_0094_),
    .Q(\buffer[1] [1]),
    .QN(_0632_),
    .RN(rst_ni)
  );
  DFFR_X1 _1315_ (
    .CK(clk_i),
    .D(_0093_),
    .Q(\buffer[1] [2]),
    .QN(_0633_),
    .RN(rst_ni)
  );
  DFFR_X1 _1316_ (
    .CK(clk_i),
    .D(_0092_),
    .Q(\buffer[1] [3]),
    .QN(_0634_),
    .RN(rst_ni)
  );
  DFFR_X1 _1317_ (
    .CK(clk_i),
    .D(_0091_),
    .Q(\buffer[1] [4]),
    .QN(_0635_),
    .RN(rst_ni)
  );
  DFFR_X1 _1318_ (
    .CK(clk_i),
    .D(_0090_),
    .Q(\buffer[1] [5]),
    .QN(_0636_),
    .RN(rst_ni)
  );
  DFFR_X1 _1319_ (
    .CK(clk_i),
    .D(_0089_),
    .Q(\buffer[1] [6]),
    .QN(_0637_),
    .RN(rst_ni)
  );
  DFFR_X1 _1320_ (
    .CK(clk_i),
    .D(_0088_),
    .Q(\buffer[1] [7]),
    .QN(_0638_),
    .RN(rst_ni)
  );
  DFFR_X1 _1321_ (
    .CK(clk_i),
    .D(_0087_),
    .Q(\buffer[1] [8]),
    .QN(_0639_),
    .RN(rst_ni)
  );
  DFFR_X1 _1322_ (
    .CK(clk_i),
    .D(_0086_),
    .Q(\buffer[1] [9]),
    .QN(_0640_),
    .RN(rst_ni)
  );
  DFFR_X1 _1323_ (
    .CK(clk_i),
    .D(_0085_),
    .Q(\buffer[1] [10]),
    .QN(_0641_),
    .RN(rst_ni)
  );
  DFFR_X1 _1324_ (
    .CK(clk_i),
    .D(_0084_),
    .Q(\buffer[1] [11]),
    .QN(_0642_),
    .RN(rst_ni)
  );
  DFFR_X1 _1325_ (
    .CK(clk_i),
    .D(_0083_),
    .Q(\buffer[1] [12]),
    .QN(_0643_),
    .RN(rst_ni)
  );
  DFFR_X1 _1326_ (
    .CK(clk_i),
    .D(_0082_),
    .Q(\buffer[1] [13]),
    .QN(_0644_),
    .RN(rst_ni)
  );
  DFFR_X1 _1327_ (
    .CK(clk_i),
    .D(_0081_),
    .Q(\buffer[1] [14]),
    .QN(_0645_),
    .RN(rst_ni)
  );
  DFFR_X1 _1328_ (
    .CK(clk_i),
    .D(_0080_),
    .Q(\buffer[1] [15]),
    .QN(_0646_),
    .RN(rst_ni)
  );
  DFFR_X1 _1329_ (
    .CK(clk_i),
    .D(_0079_),
    .Q(\buffer[1] [16]),
    .QN(_0647_),
    .RN(rst_ni)
  );
  DFFR_X1 _1330_ (
    .CK(clk_i),
    .D(_0078_),
    .Q(\buffer[1] [17]),
    .QN(_0648_),
    .RN(rst_ni)
  );
  DFFR_X1 _1331_ (
    .CK(clk_i),
    .D(_0077_),
    .Q(\buffer[1] [18]),
    .QN(_0649_),
    .RN(rst_ni)
  );
  DFFR_X1 _1332_ (
    .CK(clk_i),
    .D(_0076_),
    .Q(\buffer[1] [19]),
    .QN(_0650_),
    .RN(rst_ni)
  );
  DFFR_X1 _1333_ (
    .CK(clk_i),
    .D(_0075_),
    .Q(\buffer[1] [20]),
    .QN(_0651_),
    .RN(rst_ni)
  );
  DFFR_X1 _1334_ (
    .CK(clk_i),
    .D(_0074_),
    .Q(\buffer[1] [21]),
    .QN(_0652_),
    .RN(rst_ni)
  );
  DFFR_X1 _1335_ (
    .CK(clk_i),
    .D(_0073_),
    .Q(\buffer[1] [22]),
    .QN(_0653_),
    .RN(rst_ni)
  );
  DFFR_X1 _1336_ (
    .CK(clk_i),
    .D(_0072_),
    .Q(\buffer[1] [23]),
    .QN(_0654_),
    .RN(rst_ni)
  );
  DFFR_X1 _1337_ (
    .CK(clk_i),
    .D(_0071_),
    .Q(\buffer[1] [24]),
    .QN(_0655_),
    .RN(rst_ni)
  );
  DFFR_X1 _1338_ (
    .CK(clk_i),
    .D(_0070_),
    .Q(\buffer[1] [25]),
    .QN(_0656_),
    .RN(rst_ni)
  );
  DFFR_X1 _1339_ (
    .CK(clk_i),
    .D(_0069_),
    .Q(\buffer[1] [26]),
    .QN(_0657_),
    .RN(rst_ni)
  );
  DFFR_X1 _1340_ (
    .CK(clk_i),
    .D(_0068_),
    .Q(\buffer[1] [27]),
    .QN(_0658_),
    .RN(rst_ni)
  );
  DFFR_X1 _1341_ (
    .CK(clk_i),
    .D(_0067_),
    .Q(\buffer[1] [28]),
    .QN(_0659_),
    .RN(rst_ni)
  );
  DFFR_X1 _1342_ (
    .CK(clk_i),
    .D(_0066_),
    .Q(\buffer[1] [29]),
    .QN(_0660_),
    .RN(rst_ni)
  );
  DFFR_X1 _1343_ (
    .CK(clk_i),
    .D(_0065_),
    .Q(\buffer[1] [30]),
    .QN(_0661_),
    .RN(rst_ni)
  );
  DFFR_X1 _1344_ (
    .CK(clk_i),
    .D(_0227_),
    .Q(\buffer[1] [31]),
    .QN(_0499_),
    .RN(rst_ni)
  );
  DFFR_X1 _1345_ (
    .CK(clk_i),
    .D(_0064_),
    .Q(\buffer[2] [0]),
    .QN(_0662_),
    .RN(rst_ni)
  );
  DFFR_X1 _1346_ (
    .CK(clk_i),
    .D(_0063_),
    .Q(\buffer[2] [1]),
    .QN(_0663_),
    .RN(rst_ni)
  );
  DFFR_X1 _1347_ (
    .CK(clk_i),
    .D(_0062_),
    .Q(\buffer[2] [2]),
    .QN(_0664_),
    .RN(rst_ni)
  );
  DFFR_X1 _1348_ (
    .CK(clk_i),
    .D(_0061_),
    .Q(\buffer[2] [3]),
    .QN(_0665_),
    .RN(rst_ni)
  );
  DFFR_X1 _1349_ (
    .CK(clk_i),
    .D(_0060_),
    .Q(\buffer[2] [4]),
    .QN(_0666_),
    .RN(rst_ni)
  );
  DFFR_X1 _1350_ (
    .CK(clk_i),
    .D(_0059_),
    .Q(\buffer[2] [5]),
    .QN(_0667_),
    .RN(rst_ni)
  );
  DFFR_X1 _1351_ (
    .CK(clk_i),
    .D(_0058_),
    .Q(\buffer[2] [6]),
    .QN(_0668_),
    .RN(rst_ni)
  );
  DFFR_X1 _1352_ (
    .CK(clk_i),
    .D(_0057_),
    .Q(\buffer[2] [7]),
    .QN(_0669_),
    .RN(rst_ni)
  );
  DFFR_X1 _1353_ (
    .CK(clk_i),
    .D(_0056_),
    .Q(\buffer[2] [8]),
    .QN(_0670_),
    .RN(rst_ni)
  );
  DFFR_X1 _1354_ (
    .CK(clk_i),
    .D(_0055_),
    .Q(\buffer[2] [9]),
    .QN(_0671_),
    .RN(rst_ni)
  );
  DFFR_X1 _1355_ (
    .CK(clk_i),
    .D(_0054_),
    .Q(\buffer[2] [10]),
    .QN(_0672_),
    .RN(rst_ni)
  );
  DFFR_X1 _1356_ (
    .CK(clk_i),
    .D(_0053_),
    .Q(\buffer[2] [11]),
    .QN(_0673_),
    .RN(rst_ni)
  );
  DFFR_X1 _1357_ (
    .CK(clk_i),
    .D(_0052_),
    .Q(\buffer[2] [12]),
    .QN(_0674_),
    .RN(rst_ni)
  );
  DFFR_X1 _1358_ (
    .CK(clk_i),
    .D(_0051_),
    .Q(\buffer[2] [13]),
    .QN(_0675_),
    .RN(rst_ni)
  );
  DFFR_X1 _1359_ (
    .CK(clk_i),
    .D(_0050_),
    .Q(\buffer[2] [14]),
    .QN(_0676_),
    .RN(rst_ni)
  );
  DFFR_X1 _1360_ (
    .CK(clk_i),
    .D(_0049_),
    .Q(\buffer[2] [15]),
    .QN(_0677_),
    .RN(rst_ni)
  );
  DFFR_X1 _1361_ (
    .CK(clk_i),
    .D(_0048_),
    .Q(\buffer[2] [16]),
    .QN(_0678_),
    .RN(rst_ni)
  );
  DFFR_X1 _1362_ (
    .CK(clk_i),
    .D(_0047_),
    .Q(\buffer[2] [17]),
    .QN(_0679_),
    .RN(rst_ni)
  );
  DFFR_X1 _1363_ (
    .CK(clk_i),
    .D(_0046_),
    .Q(\buffer[2] [18]),
    .QN(_0680_),
    .RN(rst_ni)
  );
  DFFR_X1 _1364_ (
    .CK(clk_i),
    .D(_0045_),
    .Q(\buffer[2] [19]),
    .QN(_0681_),
    .RN(rst_ni)
  );
  DFFR_X1 _1365_ (
    .CK(clk_i),
    .D(_0044_),
    .Q(\buffer[2] [20]),
    .QN(_0682_),
    .RN(rst_ni)
  );
  DFFR_X1 _1366_ (
    .CK(clk_i),
    .D(_0043_),
    .Q(\buffer[2] [21]),
    .QN(_0683_),
    .RN(rst_ni)
  );
  DFFR_X1 _1367_ (
    .CK(clk_i),
    .D(_0042_),
    .Q(\buffer[2] [22]),
    .QN(_0684_),
    .RN(rst_ni)
  );
  DFFR_X1 _1368_ (
    .CK(clk_i),
    .D(_0041_),
    .Q(\buffer[2] [23]),
    .QN(_0685_),
    .RN(rst_ni)
  );
  DFFR_X1 _1369_ (
    .CK(clk_i),
    .D(_0040_),
    .Q(\buffer[2] [24]),
    .QN(_0686_),
    .RN(rst_ni)
  );
  DFFR_X1 _1370_ (
    .CK(clk_i),
    .D(_0039_),
    .Q(\buffer[2] [25]),
    .QN(_0687_),
    .RN(rst_ni)
  );
  DFFR_X1 _1371_ (
    .CK(clk_i),
    .D(_0038_),
    .Q(\buffer[2] [26]),
    .QN(_0688_),
    .RN(rst_ni)
  );
  DFFR_X1 _1372_ (
    .CK(clk_i),
    .D(_0037_),
    .Q(\buffer[2] [27]),
    .QN(_0689_),
    .RN(rst_ni)
  );
  DFFR_X1 _1373_ (
    .CK(clk_i),
    .D(_0036_),
    .Q(\buffer[2] [28]),
    .QN(_0690_),
    .RN(rst_ni)
  );
  DFFR_X1 _1374_ (
    .CK(clk_i),
    .D(_0035_),
    .Q(\buffer[2] [29]),
    .QN(_0691_),
    .RN(rst_ni)
  );
  DFFR_X1 _1375_ (
    .CK(clk_i),
    .D(_0034_),
    .Q(\buffer[2] [30]),
    .QN(_0692_),
    .RN(rst_ni)
  );
  DFFR_X1 _1376_ (
    .CK(clk_i),
    .D(_0252_),
    .Q(\buffer[2] [31]),
    .QN(_0474_),
    .RN(rst_ni)
  );
  DFFR_X1 _1377_ (
    .CK(clk_i),
    .D(_0033_),
    .Q(pointer_in[0]),
    .QN(_0693_),
    .RN(rst_ni)
  );
  DFFR_X1 _1378_ (
    .CK(clk_i),
    .D(_0032_),
    .Q(pointer_in[1]),
    .QN(_0694_),
    .RN(rst_ni)
  );
  DFFR_X1 _1379_ (
    .CK(clk_i),
    .D(_0031_),
    .Q(pointer_in[2]),
    .QN(_0695_),
    .RN(rst_ni)
  );
  DFFR_X1 _1380_ (
    .CK(clk_i),
    .D(_0030_),
    .Q(pointer_out[0]),
    .QN(_0696_),
    .RN(rst_ni)
  );
  DFFR_X1 _1381_ (
    .CK(clk_i),
    .D(_0029_),
    .Q(pointer_out[1]),
    .QN(_0697_),
    .RN(rst_ni)
  );
  DFFR_X1 _1382_ (
    .CK(clk_i),
    .D(_0028_),
    .Q(pointer_out[2]),
    .QN(_0698_),
    .RN(rst_ni)
  );
  DFFR_X1 _1383_ (
    .CK(clk_i),
    .D(_0026_),
    .Q(elements[0]),
    .QN(_0700_),
    .RN(rst_ni)
  );
  DFFR_X1 _1384_ (
    .CK(clk_i),
    .D(_0025_),
    .Q(elements[1]),
    .QN(_0701_),
    .RN(rst_ni)
  );
  DFFR_X1 _1385_ (
    .CK(clk_i),
    .D(_0024_),
    .Q(elements[2]),
    .QN(_0702_),
    .RN(rst_ni)
  );
  DFFR_X1 _1386_ (
    .CK(clk_i),
    .D(_0023_),
    .Q(elements[3]),
    .QN(_0000_),
    .RN(rst_ni)
  );
  DFFR_X1 _1387_ (
    .CK(clk_i),
    .D(_0253_),
    .Q(elements[4]),
    .QN(_0473_),
    .RN(rst_ni)
  );
  DFFR_X1 _1388_ (
    .CK(clk_i),
    .D(_0022_),
    .Q(\buffer[7] [0]),
    .QN(_0703_),
    .RN(rst_ni)
  );
  DFFR_X1 _1389_ (
    .CK(clk_i),
    .D(_0021_),
    .Q(\buffer[7] [1]),
    .QN(_0704_),
    .RN(rst_ni)
  );
  DFFR_X1 _1390_ (
    .CK(clk_i),
    .D(_0020_),
    .Q(\buffer[7] [2]),
    .QN(_0705_),
    .RN(rst_ni)
  );
  DFFR_X1 _1391_ (
    .CK(clk_i),
    .D(_0019_),
    .Q(\buffer[7] [3]),
    .QN(_0706_),
    .RN(rst_ni)
  );
  DFFR_X1 _1392_ (
    .CK(clk_i),
    .D(_0018_),
    .Q(\buffer[7] [4]),
    .QN(_0707_),
    .RN(rst_ni)
  );
  DFFR_X1 _1393_ (
    .CK(clk_i),
    .D(_0017_),
    .Q(\buffer[7] [5]),
    .QN(_0708_),
    .RN(rst_ni)
  );
  DFFR_X1 _1394_ (
    .CK(clk_i),
    .D(_0016_),
    .Q(\buffer[7] [6]),
    .QN(_0709_),
    .RN(rst_ni)
  );
  DFFR_X1 _1395_ (
    .CK(clk_i),
    .D(_0015_),
    .Q(\buffer[7] [7]),
    .QN(_0710_),
    .RN(rst_ni)
  );
  DFFR_X1 _1396_ (
    .CK(clk_i),
    .D(_0014_),
    .Q(\buffer[7] [8]),
    .QN(_0711_),
    .RN(rst_ni)
  );
  DFFR_X1 _1397_ (
    .CK(clk_i),
    .D(_0013_),
    .Q(\buffer[7] [9]),
    .QN(_0712_),
    .RN(rst_ni)
  );
  DFFR_X1 _1398_ (
    .CK(clk_i),
    .D(_0012_),
    .Q(\buffer[7] [10]),
    .QN(_0713_),
    .RN(rst_ni)
  );
  DFFR_X1 _1399_ (
    .CK(clk_i),
    .D(_0011_),
    .Q(\buffer[7] [11]),
    .QN(_0714_),
    .RN(rst_ni)
  );
  DFFR_X1 _1400_ (
    .CK(clk_i),
    .D(_0010_),
    .Q(\buffer[7] [12]),
    .QN(_0715_),
    .RN(rst_ni)
  );
  DFFR_X1 _1401_ (
    .CK(clk_i),
    .D(_0009_),
    .Q(\buffer[7] [13]),
    .QN(_0716_),
    .RN(rst_ni)
  );
  DFFR_X1 _1402_ (
    .CK(clk_i),
    .D(_0008_),
    .Q(\buffer[7] [14]),
    .QN(_0717_),
    .RN(rst_ni)
  );
  DFFR_X1 _1403_ (
    .CK(clk_i),
    .D(_0007_),
    .Q(\buffer[7] [15]),
    .QN(_0718_),
    .RN(rst_ni)
  );
  DFFR_X1 _1404_ (
    .CK(clk_i),
    .D(_0006_),
    .Q(\buffer[7] [16]),
    .QN(_0719_),
    .RN(rst_ni)
  );
  DFFR_X1 _1405_ (
    .CK(clk_i),
    .D(_0005_),
    .Q(\buffer[7] [17]),
    .QN(_0720_),
    .RN(rst_ni)
  );
  DFFR_X1 _1406_ (
    .CK(clk_i),
    .D(_0004_),
    .Q(\buffer[7] [18]),
    .QN(_0721_),
    .RN(rst_ni)
  );
  DFFR_X1 _1407_ (
    .CK(clk_i),
    .D(_0003_),
    .Q(\buffer[7] [19]),
    .QN(_0722_),
    .RN(rst_ni)
  );
  DFFR_X1 _1408_ (
    .CK(clk_i),
    .D(_0002_),
    .Q(\buffer[7] [20]),
    .QN(_0723_),
    .RN(rst_ni)
  );
  DFFR_X1 _1409_ (
    .CK(clk_i),
    .D(_0001_),
    .Q(\buffer[7] [21]),
    .QN(_0724_),
    .RN(rst_ni)
  );
  DFFR_X1 _1410_ (
    .CK(clk_i),
    .D(_0267_),
    .Q(\buffer[7] [22]),
    .QN(_0459_),
    .RN(rst_ni)
  );
  DFFR_X1 _1411_ (
    .CK(clk_i),
    .D(_0264_),
    .Q(\buffer[7] [23]),
    .QN(_0462_),
    .RN(rst_ni)
  );
  DFFR_X1 _1412_ (
    .CK(clk_i),
    .D(_0263_),
    .Q(\buffer[7] [24]),
    .QN(_0463_),
    .RN(rst_ni)
  );
  DFFR_X1 _1413_ (
    .CK(clk_i),
    .D(_0262_),
    .Q(\buffer[7] [25]),
    .QN(_0464_),
    .RN(rst_ni)
  );
  DFFR_X1 _1414_ (
    .CK(clk_i),
    .D(_0261_),
    .Q(\buffer[7] [26]),
    .QN(_0465_),
    .RN(rst_ni)
  );
  DFFR_X1 _1415_ (
    .CK(clk_i),
    .D(_0260_),
    .Q(\buffer[7] [27]),
    .QN(_0466_),
    .RN(rst_ni)
  );
  DFFR_X1 _1416_ (
    .CK(clk_i),
    .D(_0259_),
    .Q(\buffer[7] [28]),
    .QN(_0467_),
    .RN(rst_ni)
  );
  DFFR_X1 _1417_ (
    .CK(clk_i),
    .D(_0258_),
    .Q(\buffer[7] [29]),
    .QN(_0468_),
    .RN(rst_ni)
  );
  DFFR_X1 _1418_ (
    .CK(clk_i),
    .D(_0257_),
    .Q(\buffer[7] [30]),
    .QN(_0469_),
    .RN(rst_ni)
  );
  DFFR_X1 _1419_ (
    .CK(clk_i),
    .D(_0256_),
    .Q(\buffer[7] [31]),
    .QN(_0470_),
    .RN(rst_ni)
  );
  DFFR_X1 _1420_ (
    .CK(clk_i),
    .D(_0255_),
    .Q(\buffer[4] [0]),
    .QN(_0471_),
    .RN(rst_ni)
  );
  DFFR_X1 _1421_ (
    .CK(clk_i),
    .D(_0254_),
    .Q(\buffer[4] [1]),
    .QN(_0472_),
    .RN(rst_ni)
  );
  DFFR_X1 _1422_ (
    .CK(clk_i),
    .D(_0251_),
    .Q(\buffer[4] [2]),
    .QN(_0475_),
    .RN(rst_ni)
  );
  DFFR_X1 _1423_ (
    .CK(clk_i),
    .D(_0250_),
    .Q(\buffer[4] [3]),
    .QN(_0476_),
    .RN(rst_ni)
  );
  DFFR_X1 _1424_ (
    .CK(clk_i),
    .D(_0249_),
    .Q(\buffer[4] [4]),
    .QN(_0477_),
    .RN(rst_ni)
  );
  DFFR_X1 _1425_ (
    .CK(clk_i),
    .D(_0248_),
    .Q(\buffer[4] [5]),
    .QN(_0478_),
    .RN(rst_ni)
  );
  DFFR_X1 _1426_ (
    .CK(clk_i),
    .D(_0247_),
    .Q(\buffer[4] [6]),
    .QN(_0479_),
    .RN(rst_ni)
  );
  DFFR_X1 _1427_ (
    .CK(clk_i),
    .D(_0246_),
    .Q(\buffer[4] [7]),
    .QN(_0480_),
    .RN(rst_ni)
  );
  DFFR_X1 _1428_ (
    .CK(clk_i),
    .D(_0245_),
    .Q(\buffer[4] [8]),
    .QN(_0481_),
    .RN(rst_ni)
  );
  DFFR_X1 _1429_ (
    .CK(clk_i),
    .D(_0244_),
    .Q(\buffer[4] [9]),
    .QN(_0482_),
    .RN(rst_ni)
  );
  DFFR_X1 _1430_ (
    .CK(clk_i),
    .D(_0243_),
    .Q(\buffer[4] [10]),
    .QN(_0483_),
    .RN(rst_ni)
  );
  DFFR_X1 _1431_ (
    .CK(clk_i),
    .D(_0242_),
    .Q(\buffer[4] [11]),
    .QN(_0484_),
    .RN(rst_ni)
  );
  DFFR_X1 _1432_ (
    .CK(clk_i),
    .D(_0241_),
    .Q(\buffer[4] [12]),
    .QN(_0485_),
    .RN(rst_ni)
  );
  DFFR_X1 _1433_ (
    .CK(clk_i),
    .D(_0240_),
    .Q(\buffer[4] [13]),
    .QN(_0486_),
    .RN(rst_ni)
  );
  DFFR_X1 _1434_ (
    .CK(clk_i),
    .D(_0239_),
    .Q(\buffer[4] [14]),
    .QN(_0487_),
    .RN(rst_ni)
  );
  DFFR_X1 _1435_ (
    .CK(clk_i),
    .D(_0238_),
    .Q(\buffer[4] [15]),
    .QN(_0488_),
    .RN(rst_ni)
  );
  DFFR_X1 _1436_ (
    .CK(clk_i),
    .D(_0237_),
    .Q(\buffer[4] [16]),
    .QN(_0489_),
    .RN(rst_ni)
  );
  DFFR_X1 _1437_ (
    .CK(clk_i),
    .D(_0236_),
    .Q(\buffer[4] [17]),
    .QN(_0490_),
    .RN(rst_ni)
  );
  DFFR_X1 _1438_ (
    .CK(clk_i),
    .D(_0235_),
    .Q(\buffer[4] [18]),
    .QN(_0491_),
    .RN(rst_ni)
  );
  DFFR_X1 _1439_ (
    .CK(clk_i),
    .D(_0234_),
    .Q(\buffer[4] [19]),
    .QN(_0492_),
    .RN(rst_ni)
  );
  DFFR_X1 _1440_ (
    .CK(clk_i),
    .D(_0233_),
    .Q(\buffer[4] [20]),
    .QN(_0493_),
    .RN(rst_ni)
  );
  DFFR_X1 _1441_ (
    .CK(clk_i),
    .D(_0232_),
    .Q(\buffer[4] [21]),
    .QN(_0494_),
    .RN(rst_ni)
  );
  DFFR_X1 _1442_ (
    .CK(clk_i),
    .D(_0231_),
    .Q(\buffer[4] [22]),
    .QN(_0495_),
    .RN(rst_ni)
  );
  DFFR_X1 _1443_ (
    .CK(clk_i),
    .D(_0230_),
    .Q(\buffer[4] [23]),
    .QN(_0496_),
    .RN(rst_ni)
  );
  DFFR_X1 _1444_ (
    .CK(clk_i),
    .D(_0228_),
    .Q(\buffer[4] [24]),
    .QN(_0498_),
    .RN(rst_ni)
  );
  DFFR_X1 _1445_ (
    .CK(clk_i),
    .D(_0225_),
    .Q(\buffer[4] [25]),
    .QN(_0501_),
    .RN(rst_ni)
  );
  DFFR_X1 _1446_ (
    .CK(clk_i),
    .D(_0224_),
    .Q(\buffer[4] [26]),
    .QN(_0502_),
    .RN(rst_ni)
  );
  DFFR_X1 _1447_ (
    .CK(clk_i),
    .D(_0223_),
    .Q(\buffer[4] [27]),
    .QN(_0503_),
    .RN(rst_ni)
  );
  DFFR_X1 _1448_ (
    .CK(clk_i),
    .D(_0222_),
    .Q(\buffer[4] [28]),
    .QN(_0504_),
    .RN(rst_ni)
  );
  DFFR_X1 _1449_ (
    .CK(clk_i),
    .D(_0221_),
    .Q(\buffer[4] [29]),
    .QN(_0505_),
    .RN(rst_ni)
  );
  DFFR_X1 _1450_ (
    .CK(clk_i),
    .D(_0220_),
    .Q(\buffer[4] [30]),
    .QN(_0506_),
    .RN(rst_ni)
  );
  DFFR_X1 _1451_ (
    .CK(clk_i),
    .D(_0265_),
    .Q(\buffer[4] [31]),
    .QN(_0461_),
    .RN(rst_ni)
  );
  DFFR_X1 _1452_ (
    .CK(clk_i),
    .D(_0219_),
    .Q(\buffer[0] [0]),
    .QN(_0507_),
    .RN(rst_ni)
  );
  DFFR_X1 _1453_ (
    .CK(clk_i),
    .D(_0218_),
    .Q(\buffer[0] [1]),
    .QN(_0508_),
    .RN(rst_ni)
  );
  DFFR_X1 _1454_ (
    .CK(clk_i),
    .D(_0217_),
    .Q(\buffer[0] [2]),
    .QN(_0509_),
    .RN(rst_ni)
  );
  DFFR_X1 _1455_ (
    .CK(clk_i),
    .D(_0216_),
    .Q(\buffer[0] [3]),
    .QN(_0510_),
    .RN(rst_ni)
  );
  DFFR_X1 _1456_ (
    .CK(clk_i),
    .D(_0215_),
    .Q(\buffer[0] [4]),
    .QN(_0511_),
    .RN(rst_ni)
  );
  DFFR_X1 _1457_ (
    .CK(clk_i),
    .D(_0214_),
    .Q(\buffer[0] [5]),
    .QN(_0512_),
    .RN(rst_ni)
  );
  DFFR_X1 _1458_ (
    .CK(clk_i),
    .D(_0213_),
    .Q(\buffer[0] [6]),
    .QN(_0513_),
    .RN(rst_ni)
  );
  DFFR_X1 _1459_ (
    .CK(clk_i),
    .D(_0212_),
    .Q(\buffer[0] [7]),
    .QN(_0514_),
    .RN(rst_ni)
  );
  DFFR_X1 _1460_ (
    .CK(clk_i),
    .D(_0211_),
    .Q(\buffer[0] [8]),
    .QN(_0515_),
    .RN(rst_ni)
  );
  DFFR_X1 _1461_ (
    .CK(clk_i),
    .D(_0210_),
    .Q(\buffer[0] [9]),
    .QN(_0516_),
    .RN(rst_ni)
  );
  DFFR_X1 _1462_ (
    .CK(clk_i),
    .D(_0209_),
    .Q(\buffer[0] [10]),
    .QN(_0517_),
    .RN(rst_ni)
  );
  DFFR_X1 _1463_ (
    .CK(clk_i),
    .D(_0207_),
    .Q(\buffer[0] [11]),
    .QN(_0519_),
    .RN(rst_ni)
  );
  DFFR_X1 _1464_ (
    .CK(clk_i),
    .D(_0206_),
    .Q(\buffer[0] [12]),
    .QN(_0520_),
    .RN(rst_ni)
  );
  DFFR_X1 _1465_ (
    .CK(clk_i),
    .D(_0205_),
    .Q(\buffer[0] [13]),
    .QN(_0521_),
    .RN(rst_ni)
  );
  DFFR_X1 _1466_ (
    .CK(clk_i),
    .D(_0204_),
    .Q(\buffer[0] [14]),
    .QN(_0522_),
    .RN(rst_ni)
  );
  DFFR_X1 _1467_ (
    .CK(clk_i),
    .D(_0203_),
    .Q(\buffer[0] [15]),
    .QN(_0523_),
    .RN(rst_ni)
  );
  DFFR_X1 _1468_ (
    .CK(clk_i),
    .D(_0202_),
    .Q(\buffer[0] [16]),
    .QN(_0524_),
    .RN(rst_ni)
  );
  DFFR_X1 _1469_ (
    .CK(clk_i),
    .D(_0201_),
    .Q(\buffer[0] [17]),
    .QN(_0525_),
    .RN(rst_ni)
  );
  DFFR_X1 _1470_ (
    .CK(clk_i),
    .D(_0200_),
    .Q(\buffer[0] [18]),
    .QN(_0526_),
    .RN(rst_ni)
  );
  DFFR_X1 _1471_ (
    .CK(clk_i),
    .D(_0199_),
    .Q(\buffer[0] [19]),
    .QN(_0527_),
    .RN(rst_ni)
  );
  DFFR_X1 _1472_ (
    .CK(clk_i),
    .D(_0198_),
    .Q(\buffer[0] [20]),
    .QN(_0528_),
    .RN(rst_ni)
  );
  DFFR_X1 _1473_ (
    .CK(clk_i),
    .D(_0197_),
    .Q(\buffer[0] [21]),
    .QN(_0529_),
    .RN(rst_ni)
  );
  DFFR_X1 _1474_ (
    .CK(clk_i),
    .D(_0196_),
    .Q(\buffer[0] [22]),
    .QN(_0530_),
    .RN(rst_ni)
  );
  DFFR_X1 _1475_ (
    .CK(clk_i),
    .D(_0195_),
    .Q(\buffer[0] [23]),
    .QN(_0531_),
    .RN(rst_ni)
  );
  DFFR_X1 _1476_ (
    .CK(clk_i),
    .D(_0194_),
    .Q(\buffer[0] [24]),
    .QN(_0532_),
    .RN(rst_ni)
  );
  DFFR_X1 _1477_ (
    .CK(clk_i),
    .D(_0193_),
    .Q(\buffer[0] [25]),
    .QN(_0533_),
    .RN(rst_ni)
  );
  DFFR_X1 _1478_ (
    .CK(clk_i),
    .D(_0192_),
    .Q(\buffer[0] [26]),
    .QN(_0534_),
    .RN(rst_ni)
  );
  DFFR_X1 _1479_ (
    .CK(clk_i),
    .D(_0191_),
    .Q(\buffer[0] [27]),
    .QN(_0535_),
    .RN(rst_ni)
  );
  DFFR_X1 _1480_ (
    .CK(clk_i),
    .D(_0190_),
    .Q(\buffer[0] [28]),
    .QN(_0536_),
    .RN(rst_ni)
  );
  DFFR_X1 _1481_ (
    .CK(clk_i),
    .D(_0189_),
    .Q(\buffer[0] [29]),
    .QN(_0537_),
    .RN(rst_ni)
  );
  DFFR_X1 _1482_ (
    .CK(clk_i),
    .D(_0027_),
    .Q(\buffer[0] [30]),
    .QN(_0699_),
    .RN(rst_ni)
  );
  DFFR_X1 _1483_ (
    .CK(clk_i),
    .D(_0266_),
    .Q(\buffer[0] [31]),
    .QN(_0460_),
    .RN(rst_ni)
  );
  assign elements_o = elements;
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

module pulp_spi_wrap(clk, rst_n, secure_mode, s_awaddr, s_awvalid, s_awready, s_wdata, s_wstrb, s_wvalid, s_wready, s_bresp, s_bvalid, s_bready, s_araddr, s_arvalid, s_arready, s_rdata, s_rresp, s_rvalid, s_rready, spi_sck
, spi_mosi, spi_miso, spi_cs_n, irq);
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
  output spi_sck;
  wire spi_sck;
  output spi_mosi;
  wire spi_mosi;
  input spi_miso;
  wire spi_miso;
  output spi_cs_n;
  wire spi_cs_n;
  output irq;
  wire irq;
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
  wire [11:0] apb_paddr;
  wire apb_penable;
  wire [31:0] apb_prdata;
  wire apb_pready;
  wire apb_psel;
  wire apb_pslverr;
  wire [31:0] apb_pwdata;
  wire apb_pwrite;
  wire cs_lock_r;
  wire [1:0] events_raw;
  wire fwd_arready;
  wire fwd_arvalid;
  wire fwd_awready;
  wire fwd_awvalid;
  wire [1:0] fwd_bresp;
  wire fwd_bvalid;
  wire [31:0] fwd_rdata;
  wire [1:0] fwd_rresp;
  wire fwd_rvalid;
  wire fwd_wready;
  wire fwd_wvalid;
  wire [31:0] lrd_rdata_r;
  wire [1:0] lrd_state_r;
  wire [11:0] lwr_addr_r;
  wire [2:0] lwr_state_r;
  wire [7:0] max_len_r;
  wire [31:0] pwdata_gated;
  wire [3:0] spi_csn_raw;
  wire [1:0] spi_mode_nc;
  wire spi_mosi_raw;
  wire spi_sck_raw;
  INV_X1 _158_ (
    .A(lrd_state_r[1]),
    .ZN(_034_)
  );
  INV_X1 _159_ (
    .A(lwr_state_r[1]),
    .ZN(_035_)
  );
  INV_X1 _160_ (
    .A(s_araddr[5]),
    .ZN(_036_)
  );
  INV_X1 _161_ (
    .A(s_araddr[0]),
    .ZN(_037_)
  );
  INV_X1 _162_ (
    .A(max_len_r[6]),
    .ZN(_038_)
  );
  INV_X1 _163_ (
    .A(cs_lock_r),
    .ZN(_039_)
  );
  INV_X1 _164_ (
    .A(max_len_r[7]),
    .ZN(_040_)
  );
  INV_X1 _165_ (
    .A(apb_pwdata[5]),
    .ZN(_041_)
  );
  INV_X1 _166_ (
    .A(apb_pwdata[4]),
    .ZN(_042_)
  );
  INV_X1 _167_ (
    .A(apb_pwdata[3]),
    .ZN(_043_)
  );
  INV_X1 _168_ (
    .A(apb_pwdata[2]),
    .ZN(_044_)
  );
  INV_X1 _169_ (
    .A(apb_pwdata[1]),
    .ZN(_045_)
  );
  INV_X1 _170_ (
    .A(apb_pwdata[0]),
    .ZN(_046_)
  );
  INV_X1 _171_ (
    .A(apb_psel),
    .ZN(_047_)
  );
  INV_X1 _172_ (
    .A(apb_penable),
    .ZN(_048_)
  );
  INV_X1 _173_ (
    .A(lwr_state_r[2]),
    .ZN(_049_)
  );
  INV_X1 _174_ (
    .A(s_awaddr[0]),
    .ZN(_050_)
  );
  INV_X1 _175_ (
    .A(s_awaddr[1]),
    .ZN(_051_)
  );
  INV_X1 _176_ (
    .A(s_arvalid),
    .ZN(_052_)
  );
  INV_X1 _177_ (
    .A(spi_sck_raw),
    .ZN(_053_)
  );
  INV_X1 _178_ (
    .A(spi_mosi_raw),
    .ZN(_054_)
  );
  INV_X1 _179_ (
    .A(lwr_addr_r[5]),
    .ZN(_055_)
  );
  INV_X1 _180_ (
    .A(lwr_addr_r[4]),
    .ZN(_056_)
  );
  INV_X1 _181_ (
    .A(lwr_addr_r[3]),
    .ZN(_057_)
  );
  INV_X1 _182_ (
    .A(lwr_addr_r[7]),
    .ZN(_058_)
  );
  INV_X1 _183_ (
    .A(lwr_addr_r[6]),
    .ZN(_059_)
  );
  INV_X1 _184_ (
    .A(fwd_awready),
    .ZN(_060_)
  );
  AND2_X1 _185_ (
    .A1(fwd_rdata[19]),
    .A2(_034_),
    .ZN(s_rdata[19])
  );
  AND2_X1 _186_ (
    .A1(_034_),
    .A2(fwd_rdata[18]),
    .ZN(s_rdata[18])
  );
  AND2_X1 _187_ (
    .A1(_034_),
    .A2(fwd_rdata[17]),
    .ZN(s_rdata[17])
  );
  AND2_X1 _188_ (
    .A1(_034_),
    .A2(fwd_rdata[16]),
    .ZN(s_rdata[16])
  );
  AND2_X1 _189_ (
    .A1(_034_),
    .A2(fwd_rdata[15]),
    .ZN(s_rdata[15])
  );
  AND2_X1 _190_ (
    .A1(_034_),
    .A2(fwd_rdata[14]),
    .ZN(s_rdata[14])
  );
  AND2_X1 _191_ (
    .A1(_034_),
    .A2(fwd_rdata[13]),
    .ZN(s_rdata[13])
  );
  AND2_X1 _192_ (
    .A1(_034_),
    .A2(fwd_rdata[12]),
    .ZN(s_rdata[12])
  );
  AND2_X1 _193_ (
    .A1(_034_),
    .A2(fwd_rdata[11]),
    .ZN(s_rdata[11])
  );
  AND2_X1 _194_ (
    .A1(_034_),
    .A2(fwd_rdata[10]),
    .ZN(s_rdata[10])
  );
  AND2_X1 _195_ (
    .A1(_034_),
    .A2(fwd_rdata[9]),
    .ZN(s_rdata[9])
  );
  AND2_X1 _196_ (
    .A1(_034_),
    .A2(fwd_rdata[8]),
    .ZN(s_rdata[8])
  );
  MUX2_X1 _197_ (
    .A(fwd_rdata[7]),
    .B(lrd_rdata_r[7]),
    .S(lrd_state_r[1]),
    .Z(s_rdata[7])
  );
  MUX2_X1 _198_ (
    .A(fwd_rdata[6]),
    .B(lrd_rdata_r[6]),
    .S(lrd_state_r[1]),
    .Z(s_rdata[6])
  );
  MUX2_X1 _199_ (
    .A(fwd_rdata[5]),
    .B(lrd_rdata_r[5]),
    .S(lrd_state_r[1]),
    .Z(s_rdata[5])
  );
  MUX2_X1 _200_ (
    .A(fwd_rdata[4]),
    .B(lrd_rdata_r[4]),
    .S(lrd_state_r[1]),
    .Z(s_rdata[4])
  );
  MUX2_X1 _201_ (
    .A(fwd_rdata[3]),
    .B(lrd_rdata_r[3]),
    .S(lrd_state_r[1]),
    .Z(s_rdata[3])
  );
  MUX2_X1 _202_ (
    .A(fwd_rdata[2]),
    .B(lrd_rdata_r[2]),
    .S(lrd_state_r[1]),
    .Z(s_rdata[2])
  );
  MUX2_X1 _203_ (
    .A(fwd_rdata[1]),
    .B(lrd_rdata_r[1]),
    .S(lrd_state_r[1]),
    .Z(s_rdata[1])
  );
  MUX2_X1 _204_ (
    .A(fwd_rdata[0]),
    .B(lrd_rdata_r[0]),
    .S(lrd_state_r[1]),
    .Z(s_rdata[0])
  );
  AND2_X1 _205_ (
    .A1(fwd_bresp[0]),
    .A2(_035_),
    .ZN(s_bresp[0])
  );
  AND2_X1 _206_ (
    .A1(_034_),
    .A2(fwd_rdata[27]),
    .ZN(s_rdata[27])
  );
  AND2_X1 _207_ (
    .A1(_034_),
    .A2(fwd_rdata[20]),
    .ZN(s_rdata[20])
  );
  AND2_X1 _208_ (
    .A1(_034_),
    .A2(fwd_rdata[23]),
    .ZN(s_rdata[23])
  );
  AND2_X1 _209_ (
    .A1(_034_),
    .A2(fwd_rdata[22]),
    .ZN(s_rdata[22])
  );
  AND2_X1 _210_ (
    .A1(_034_),
    .A2(fwd_rdata[21]),
    .ZN(s_rdata[21])
  );
  AND2_X1 _211_ (
    .A1(_034_),
    .A2(fwd_rdata[26]),
    .ZN(s_rdata[26])
  );
  AND2_X1 _212_ (
    .A1(_034_),
    .A2(fwd_rdata[25]),
    .ZN(s_rdata[25])
  );
  AND2_X1 _213_ (
    .A1(_034_),
    .A2(fwd_rdata[24]),
    .ZN(s_rdata[24])
  );
  OAI22_X1 _214_ (
    .A1(max_len_r[1]),
    .A2(_045_),
    .B1(_046_),
    .B2(max_len_r[0]),
    .ZN(_061_)
  );
  AOI22_X1 _215_ (
    .A1(max_len_r[2]),
    .A2(_044_),
    .B1(_045_),
    .B2(max_len_r[1]),
    .ZN(_062_)
  );
  OAI22_X1 _216_ (
    .A1(max_len_r[3]),
    .A2(_043_),
    .B1(_044_),
    .B2(max_len_r[2]),
    .ZN(_063_)
  );
  AOI21_X1 _217_ (
    .A(_063_),
    .B1(_062_),
    .B2(_061_),
    .ZN(_064_)
  );
  AOI221_X1 _218_ (
    .A(_064_),
    .B1(_043_),
    .B2(max_len_r[3]),
    .C1(max_len_r[4]),
    .C2(_042_),
    .ZN(_065_)
  );
  OAI22_X1 _219_ (
    .A1(max_len_r[5]),
    .A2(_041_),
    .B1(_042_),
    .B2(max_len_r[4]),
    .ZN(_066_)
  );
  NAND2_X1 _220_ (
    .A1(max_len_r[5]),
    .A2(_041_),
    .ZN(_067_)
  );
  OAI221_X1 _221_ (
    .A(_067_),
    .B1(_066_),
    .B2(_065_),
    .C1(_038_),
    .C2(apb_pwdata[6]),
    .ZN(_068_)
  );
  AOI22_X1 _222_ (
    .A1(_038_),
    .A2(apb_pwdata[6]),
    .B1(_040_),
    .B2(apb_pwdata[7]),
    .ZN(_069_)
  );
  NOR2_X1 _223_ (
    .A1(_040_),
    .A2(apb_pwdata[7]),
    .ZN(_070_)
  );
  NOR4_X1 _224_ (
    .A1(apb_paddr[0]),
    .A2(apb_paddr[5]),
    .A3(apb_paddr[10]),
    .A4(apb_paddr[8]),
    .ZN(_071_)
  );
  NOR3_X1 _225_ (
    .A1(apb_paddr[7]),
    .A2(apb_paddr[4]),
    .A3(apb_paddr[9]),
    .ZN(_072_)
  );
  NAND2_X1 _226_ (
    .A1(apb_pwrite),
    .A2(apb_paddr[3]),
    .ZN(_073_)
  );
  NOR3_X1 _227_ (
    .A1(apb_paddr[1]),
    .A2(apb_paddr[6]),
    .A3(_073_),
    .ZN(_074_)
  );
  NOR4_X1 _228_ (
    .A1(apb_paddr[2]),
    .A2(_047_),
    .A3(_048_),
    .A4(apb_paddr[11]),
    .ZN(_075_)
  );
  NAND4_X1 _229_ (
    .A1(_071_),
    .A2(_072_),
    .A3(_074_),
    .A4(_075_),
    .ZN(_076_)
  );
  AOI211_X1 _230_ (
    .A(_070_),
    .B(_076_),
    .C1(_068_),
    .C2(_069_),
    .ZN(_077_)
  );
  MUX2_X1 _231_ (
    .A(apb_pwdata[6]),
    .B(max_len_r[6]),
    .S(_077_),
    .Z(pwdata_gated[6])
  );
  MUX2_X1 _232_ (
    .A(apb_pwdata[5]),
    .B(max_len_r[5]),
    .S(_077_),
    .Z(pwdata_gated[5])
  );
  MUX2_X1 _233_ (
    .A(apb_pwdata[4]),
    .B(max_len_r[4]),
    .S(_077_),
    .Z(pwdata_gated[4])
  );
  MUX2_X1 _234_ (
    .A(apb_pwdata[3]),
    .B(max_len_r[3]),
    .S(_077_),
    .Z(pwdata_gated[3])
  );
  MUX2_X1 _235_ (
    .A(apb_pwdata[2]),
    .B(max_len_r[2]),
    .S(_077_),
    .Z(pwdata_gated[2])
  );
  MUX2_X1 _236_ (
    .A(apb_pwdata[1]),
    .B(max_len_r[1]),
    .S(_077_),
    .Z(pwdata_gated[1])
  );
  MUX2_X1 _237_ (
    .A(apb_pwdata[0]),
    .B(max_len_r[0]),
    .S(_077_),
    .Z(pwdata_gated[0])
  );
  AND2_X1 _238_ (
    .A1(_034_),
    .A2(fwd_rdata[28]),
    .ZN(s_rdata[28])
  );
  AND2_X1 _239_ (
    .A1(_034_),
    .A2(fwd_rdata[29]),
    .ZN(s_rdata[29])
  );
  AND2_X1 _240_ (
    .A1(_034_),
    .A2(fwd_rdata[30]),
    .ZN(s_rdata[30])
  );
  AND2_X1 _241_ (
    .A1(_034_),
    .A2(fwd_rresp[0]),
    .ZN(s_rresp[0])
  );
  NAND2_X1 _242_ (
    .A1(lwr_state_r[2]),
    .A2(s_wvalid),
    .ZN(_078_)
  );
  OAI21_X1 _243_ (
    .A(_078_),
    .B1(s_bready),
    .B2(_035_),
    .ZN(_001_)
  );
  OR4_X1 _244_ (
    .A1(s_awaddr[10]),
    .A2(s_awaddr[11]),
    .A3(s_awaddr[8]),
    .A4(s_awaddr[9]),
    .ZN(_079_)
  );
  NAND4_X1 _245_ (
    .A1(_050_),
    .A2(_051_),
    .A3(s_awaddr[7]),
    .A4(s_awaddr[6]),
    .ZN(_080_)
  );
  NAND4_X1 _246_ (
    .A1(s_awaddr[5]),
    .A2(s_awaddr[4]),
    .A3(s_awaddr[3]),
    .A4(s_awvalid),
    .ZN(_081_)
  );
  NOR3_X1 _247_ (
    .A1(_079_),
    .A2(_080_),
    .A3(_081_),
    .ZN(_082_)
  );
  NAND4_X1 _248_ (
    .A1(s_awaddr[4]),
    .A2(s_awaddr[3]),
    .A3(_051_),
    .A4(s_awaddr[7]),
    .ZN(_083_)
  );
  NAND4_X1 _249_ (
    .A1(s_awaddr[5]),
    .A2(s_awvalid),
    .A3(_050_),
    .A4(s_awaddr[6]),
    .ZN(_084_)
  );
  OR3_X1 _250_ (
    .A1(_079_),
    .A2(_083_),
    .A3(_084_),
    .ZN(_085_)
  );
  AOI22_X1 _251_ (
    .A1(lwr_state_r[1]),
    .A2(s_bready),
    .B1(lwr_state_r[0]),
    .B2(_085_),
    .ZN(_086_)
  );
  INV_X1 _252_ (
    .A(_086_),
    .ZN(_000_)
  );
  NOR3_X1 _253_ (
    .A1(s_araddr[11]),
    .A2(s_araddr[8]),
    .A3(s_araddr[9]),
    .ZN(_087_)
  );
  NAND4_X1 _254_ (
    .A1(s_araddr[4]),
    .A2(s_araddr[3]),
    .A3(s_araddr[7]),
    .A4(s_araddr[6]),
    .ZN(_088_)
  );
  NOR2_X1 _255_ (
    .A1(s_araddr[1]),
    .A2(s_araddr[10]),
    .ZN(_089_)
  );
  NAND4_X1 _256_ (
    .A1(s_araddr[5]),
    .A2(_037_),
    .A3(_087_),
    .A4(_089_),
    .ZN(_090_)
  );
  NOR2_X1 _257_ (
    .A1(_088_),
    .A2(_090_),
    .ZN(_091_)
  );
  NAND2_X1 _258_ (
    .A1(s_arvalid),
    .A2(_091_),
    .ZN(_092_)
  );
  NAND4_X1 _259_ (
    .A1(s_araddr[3]),
    .A2(s_araddr[7]),
    .A3(s_araddr[6]),
    .A4(_087_),
    .ZN(_093_)
  );
  NOR3_X1 _260_ (
    .A1(_036_),
    .A2(s_araddr[1]),
    .A3(s_araddr[10]),
    .ZN(_094_)
  );
  NAND3_X1 _261_ (
    .A1(s_araddr[4]),
    .A2(_037_),
    .A3(_094_),
    .ZN(_095_)
  );
  AOI22_X1 _262_ (
    .A1(lrd_state_r[1]),
    .A2(s_rready),
    .B1(_092_),
    .B2(lrd_state_r[0]),
    .ZN(_096_)
  );
  INV_X1 _263_ (
    .A(_096_),
    .ZN(_003_)
  );
  OR3_X1 _264_ (
    .A1(cs_lock_r),
    .A2(secure_mode),
    .A3(spi_csn_raw[0]),
    .ZN(spi_cs_n)
  );
  NOR2_X1 _265_ (
    .A1(secure_mode),
    .A2(_053_),
    .ZN(spi_sck)
  );
  NOR2_X1 _266_ (
    .A1(secure_mode),
    .A2(_054_),
    .ZN(spi_mosi)
  );
  AND2_X1 _267_ (
    .A1(_034_),
    .A2(fwd_rresp[1]),
    .ZN(s_rresp[1])
  );
  AND2_X1 _268_ (
    .A1(_034_),
    .A2(fwd_rdata[31]),
    .ZN(s_rdata[31])
  );
  OR2_X1 _269_ (
    .A1(lrd_state_r[1]),
    .A2(fwd_rvalid),
    .ZN(s_rvalid)
  );
  NAND2_X1 _270_ (
    .A1(lwr_state_r[0]),
    .A2(_082_),
    .ZN(_097_)
  );
  OAI21_X1 _271_ (
    .A(_097_),
    .B1(s_wvalid),
    .B2(_049_),
    .ZN(_002_)
  );
  NAND2_X1 _272_ (
    .A1(fwd_arready),
    .A2(_092_),
    .ZN(_098_)
  );
  NAND3_X1 _273_ (
    .A1(s_arvalid),
    .A2(lrd_state_r[0]),
    .A3(_091_),
    .ZN(_099_)
  );
  NAND2_X1 _274_ (
    .A1(_098_),
    .A2(_099_),
    .ZN(s_arready)
  );
  AND2_X1 _275_ (
    .A1(_035_),
    .A2(fwd_bresp[1]),
    .ZN(s_bresp[1])
  );
  OR2_X1 _276_ (
    .A1(lwr_state_r[1]),
    .A2(fwd_bvalid),
    .ZN(s_bvalid)
  );
  OR2_X1 _277_ (
    .A1(lwr_state_r[2]),
    .A2(fwd_wready),
    .ZN(s_wready)
  );
  OAI21_X1 _278_ (
    .A(_097_),
    .B1(_082_),
    .B2(_060_),
    .ZN(s_awready)
  );
  OAI21_X1 _279_ (
    .A(apb_pwdata[7]),
    .B1(_076_),
    .B2(max_len_r[7]),
    .ZN(_100_)
  );
  INV_X1 _280_ (
    .A(_100_),
    .ZN(pwdata_gated[7])
  );
  NOR2_X1 _281_ (
    .A1(_052_),
    .A2(_091_),
    .ZN(fwd_arvalid)
  );
  AND2_X1 _282_ (
    .A1(s_wvalid),
    .A2(lwr_state_r[0]),
    .ZN(fwd_wvalid)
  );
  AND2_X1 _283_ (
    .A1(s_awvalid),
    .A2(_085_),
    .ZN(fwd_awvalid)
  );
  OAI21_X1 _284_ (
    .A(_099_),
    .B1(s_rready),
    .B2(_034_),
    .ZN(_004_)
  );
  NOR2_X1 _285_ (
    .A1(lwr_addr_r[11]),
    .A2(lwr_addr_r[8]),
    .ZN(_101_)
  );
  NOR4_X1 _286_ (
    .A1(_055_),
    .A2(lwr_addr_r[0]),
    .A3(_058_),
    .A4(_059_),
    .ZN(_102_)
  );
  OR3_X1 _287_ (
    .A1(lwr_addr_r[10]),
    .A2(lwr_addr_r[9]),
    .A3(_078_),
    .ZN(_103_)
  );
  NOR4_X1 _288_ (
    .A1(_056_),
    .A2(_057_),
    .A3(lwr_addr_r[1]),
    .A4(_103_),
    .ZN(_104_)
  );
  NAND3_X1 _289_ (
    .A1(_101_),
    .A2(_102_),
    .A3(_104_),
    .ZN(_105_)
  );
  OR2_X1 _290_ (
    .A1(lwr_addr_r[2]),
    .A2(_105_),
    .ZN(_106_)
  );
  MUX2_X1 _291_ (
    .A(s_wdata[0]),
    .B(max_len_r[0]),
    .S(_106_),
    .Z(_005_)
  );
  MUX2_X1 _292_ (
    .A(s_wdata[7]),
    .B(max_len_r[7]),
    .S(_106_),
    .Z(_006_)
  );
  AND2_X1 _293_ (
    .A1(lwr_addr_r[10]),
    .A2(_097_),
    .ZN(_007_)
  );
  AND2_X1 _294_ (
    .A1(lwr_addr_r[9]),
    .A2(_097_),
    .ZN(_008_)
  );
  AND2_X1 _295_ (
    .A1(lwr_addr_r[8]),
    .A2(_097_),
    .ZN(_009_)
  );
  NAND2_X1 _296_ (
    .A1(_058_),
    .A2(_097_),
    .ZN(_010_)
  );
  NAND2_X1 _297_ (
    .A1(_059_),
    .A2(_097_),
    .ZN(_011_)
  );
  NAND2_X1 _298_ (
    .A1(_055_),
    .A2(_097_),
    .ZN(_012_)
  );
  NAND2_X1 _299_ (
    .A1(_056_),
    .A2(_097_),
    .ZN(_013_)
  );
  NAND2_X1 _300_ (
    .A1(_057_),
    .A2(_097_),
    .ZN(_014_)
  );
  MUX2_X1 _301_ (
    .A(s_awaddr[2]),
    .B(lwr_addr_r[2]),
    .S(_097_),
    .Z(_015_)
  );
  AND2_X1 _302_ (
    .A1(lwr_addr_r[11]),
    .A2(_097_),
    .ZN(_016_)
  );
  NAND2_X1 _303_ (
    .A1(lrd_rdata_r[6]),
    .A2(_099_),
    .ZN(_107_)
  );
  NOR3_X1 _304_ (
    .A1(s_araddr[2]),
    .A2(_093_),
    .A3(_095_),
    .ZN(_108_)
  );
  NAND2_X1 _305_ (
    .A1(max_len_r[6]),
    .A2(_108_),
    .ZN(_109_)
  );
  OAI21_X1 _306_ (
    .A(_107_),
    .B1(_109_),
    .B2(_099_),
    .ZN(_017_)
  );
  NAND2_X1 _307_ (
    .A1(lrd_rdata_r[7]),
    .A2(_099_),
    .ZN(_110_)
  );
  NAND2_X1 _308_ (
    .A1(max_len_r[7]),
    .A2(_108_),
    .ZN(_111_)
  );
  OAI21_X1 _309_ (
    .A(_110_),
    .B1(_111_),
    .B2(_099_),
    .ZN(_018_)
  );
  NAND2_X1 _310_ (
    .A1(lrd_rdata_r[5]),
    .A2(_099_),
    .ZN(_112_)
  );
  NAND2_X1 _311_ (
    .A1(max_len_r[5]),
    .A2(_108_),
    .ZN(_113_)
  );
  OAI21_X1 _312_ (
    .A(_112_),
    .B1(_113_),
    .B2(_099_),
    .ZN(_019_)
  );
  NAND2_X1 _313_ (
    .A1(lrd_rdata_r[4]),
    .A2(_099_),
    .ZN(_114_)
  );
  NAND2_X1 _314_ (
    .A1(max_len_r[4]),
    .A2(_108_),
    .ZN(_115_)
  );
  OAI21_X1 _315_ (
    .A(_114_),
    .B1(_115_),
    .B2(_099_),
    .ZN(_020_)
  );
  NAND2_X1 _316_ (
    .A1(lwr_addr_r[2]),
    .A2(s_wdata[0]),
    .ZN(_116_)
  );
  OAI21_X1 _317_ (
    .A(_039_),
    .B1(_105_),
    .B2(_116_),
    .ZN(_021_)
  );
  NAND2_X1 _318_ (
    .A1(lrd_rdata_r[3]),
    .A2(_099_),
    .ZN(_117_)
  );
  NAND2_X1 _319_ (
    .A1(max_len_r[3]),
    .A2(_108_),
    .ZN(_118_)
  );
  OAI21_X1 _320_ (
    .A(_117_),
    .B1(_118_),
    .B2(_099_),
    .ZN(_022_)
  );
  NAND2_X1 _321_ (
    .A1(lrd_rdata_r[2]),
    .A2(_099_),
    .ZN(_119_)
  );
  NAND2_X1 _322_ (
    .A1(max_len_r[2]),
    .A2(_108_),
    .ZN(_120_)
  );
  OAI21_X1 _323_ (
    .A(_119_),
    .B1(_120_),
    .B2(_099_),
    .ZN(_023_)
  );
  NAND2_X1 _324_ (
    .A1(lrd_rdata_r[1]),
    .A2(_099_),
    .ZN(_121_)
  );
  NAND2_X1 _325_ (
    .A1(max_len_r[1]),
    .A2(_108_),
    .ZN(_122_)
  );
  OAI21_X1 _326_ (
    .A(_121_),
    .B1(_122_),
    .B2(_099_),
    .ZN(_024_)
  );
  MUX2_X1 _327_ (
    .A(max_len_r[0]),
    .B(cs_lock_r),
    .S(s_araddr[2]),
    .Z(_123_)
  );
  MUX2_X1 _328_ (
    .A(_123_),
    .B(lrd_rdata_r[0]),
    .S(_099_),
    .Z(_025_)
  );
  AND2_X1 _329_ (
    .A1(lwr_addr_r[1]),
    .A2(_097_),
    .ZN(_026_)
  );
  AND2_X1 _330_ (
    .A1(lwr_addr_r[0]),
    .A2(_097_),
    .ZN(_027_)
  );
  MUX2_X1 _331_ (
    .A(s_wdata[6]),
    .B(max_len_r[6]),
    .S(_106_),
    .Z(_028_)
  );
  MUX2_X1 _332_ (
    .A(s_wdata[5]),
    .B(max_len_r[5]),
    .S(_106_),
    .Z(_029_)
  );
  MUX2_X1 _333_ (
    .A(s_wdata[4]),
    .B(max_len_r[4]),
    .S(_106_),
    .Z(_030_)
  );
  MUX2_X1 _334_ (
    .A(s_wdata[3]),
    .B(max_len_r[3]),
    .S(_106_),
    .Z(_031_)
  );
  MUX2_X1 _335_ (
    .A(s_wdata[2]),
    .B(max_len_r[2]),
    .S(_106_),
    .Z(_032_)
  );
  MUX2_X1 _336_ (
    .A(s_wdata[1]),
    .B(max_len_r[1]),
    .S(_106_),
    .Z(_033_)
  );
  DFFR_X1 _337_ (
    .CK(clk),
    .D(_025_),
    .Q(lrd_rdata_r[0]),
    .QN(_132_),
    .RN(rst_n)
  );
  DFFR_X1 _338_ (
    .CK(clk),
    .D(_024_),
    .Q(lrd_rdata_r[1]),
    .QN(_133_),
    .RN(rst_n)
  );
  DFFR_X1 _339_ (
    .CK(clk),
    .D(_023_),
    .Q(lrd_rdata_r[2]),
    .QN(_134_),
    .RN(rst_n)
  );
  DFFR_X1 _340_ (
    .CK(clk),
    .D(_022_),
    .Q(lrd_rdata_r[3]),
    .QN(_135_),
    .RN(rst_n)
  );
  DFFR_X1 _341_ (
    .CK(clk),
    .D(_020_),
    .Q(lrd_rdata_r[4]),
    .QN(_137_),
    .RN(rst_n)
  );
  DFFR_X1 _342_ (
    .CK(clk),
    .D(_019_),
    .Q(lrd_rdata_r[5]),
    .QN(_138_),
    .RN(rst_n)
  );
  DFFR_X1 _343_ (
    .CK(clk),
    .D(_017_),
    .Q(lrd_rdata_r[6]),
    .QN(_140_),
    .RN(rst_n)
  );
  DFFR_X1 _344_ (
    .CK(clk),
    .D(_018_),
    .Q(lrd_rdata_r[7]),
    .QN(_139_),
    .RN(rst_n)
  );
  DFFS_X1 _345_ (
    .CK(clk),
    .D(_005_),
    .Q(max_len_r[0]),
    .QN(_153_),
    .SN(rst_n)
  );
  DFFS_X1 _346_ (
    .CK(clk),
    .D(_033_),
    .Q(max_len_r[1]),
    .QN(_124_),
    .SN(rst_n)
  );
  DFFS_X1 _347_ (
    .CK(clk),
    .D(_032_),
    .Q(max_len_r[2]),
    .QN(_125_),
    .SN(rst_n)
  );
  DFFS_X1 _348_ (
    .CK(clk),
    .D(_031_),
    .Q(max_len_r[3]),
    .QN(_126_),
    .SN(rst_n)
  );
  DFFS_X1 _349_ (
    .CK(clk),
    .D(_030_),
    .Q(max_len_r[4]),
    .QN(_127_),
    .SN(rst_n)
  );
  DFFS_X1 _350_ (
    .CK(clk),
    .D(_029_),
    .Q(max_len_r[5]),
    .QN(_128_),
    .SN(rst_n)
  );
  DFFS_X1 _351_ (
    .CK(clk),
    .D(_028_),
    .Q(max_len_r[6]),
    .QN(_157_),
    .SN(rst_n)
  );
  DFFS_X1 _352_ (
    .CK(clk),
    .D(_006_),
    .Q(max_len_r[7]),
    .QN(_154_),
    .SN(rst_n)
  );
  DFFR_X1 _353_ (
    .CK(clk),
    .D(_027_),
    .Q(lwr_addr_r[0]),
    .QN(_130_),
    .RN(rst_n)
  );
  DFFR_X1 _354_ (
    .CK(clk),
    .D(_026_),
    .Q(lwr_addr_r[1]),
    .QN(_131_),
    .RN(rst_n)
  );
  DFFR_X1 _355_ (
    .CK(clk),
    .D(_015_),
    .Q(lwr_addr_r[2]),
    .QN(_142_),
    .RN(rst_n)
  );
  DFFR_X1 _356_ (
    .CK(clk),
    .D(_014_),
    .Q(lwr_addr_r[3]),
    .QN(_143_),
    .RN(rst_n)
  );
  DFFR_X1 _357_ (
    .CK(clk),
    .D(_013_),
    .Q(lwr_addr_r[4]),
    .QN(_144_),
    .RN(rst_n)
  );
  DFFR_X1 _358_ (
    .CK(clk),
    .D(_012_),
    .Q(lwr_addr_r[5]),
    .QN(_145_),
    .RN(rst_n)
  );
  DFFR_X1 _359_ (
    .CK(clk),
    .D(_011_),
    .Q(lwr_addr_r[6]),
    .QN(_156_),
    .RN(rst_n)
  );
  DFFR_X1 _360_ (
    .CK(clk),
    .D(_010_),
    .Q(lwr_addr_r[7]),
    .QN(_147_),
    .RN(rst_n)
  );
  DFFR_X1 _361_ (
    .CK(clk),
    .D(_009_),
    .Q(lwr_addr_r[8]),
    .QN(_148_),
    .RN(rst_n)
  );
  DFFR_X1 _362_ (
    .CK(clk),
    .D(_008_),
    .Q(lwr_addr_r[9]),
    .QN(_149_),
    .RN(rst_n)
  );
  DFFR_X1 _363_ (
    .CK(clk),
    .D(_007_),
    .Q(lwr_addr_r[10]),
    .QN(_150_),
    .RN(rst_n)
  );
  DFFR_X1 _364_ (
    .CK(clk),
    .D(_016_),
    .Q(lwr_addr_r[11]),
    .QN(_141_),
    .RN(rst_n)
  );
  DFFR_X1 _365_ (
    .CK(clk),
    .D(_021_),
    .Q(cs_lock_r),
    .QN(_136_),
    .RN(rst_n)
  );
  DFFS_X1 _366_ (
    .CK(clk),
    .D(_003_),
    .Q(lrd_state_r[0]),
    .QN(_155_),
    .SN(rst_n)
  );
  DFFR_X1 _367_ (
    .CK(clk),
    .D(_004_),
    .Q(lrd_state_r[1]),
    .QN(_129_),
    .RN(rst_n)
  );
  DFFS_X1 _368_ (
    .CK(clk),
    .D(_000_),
    .Q(lwr_state_r[0]),
    .QN(_152_),
    .SN(rst_n)
  );
  DFFR_X1 _369_ (
    .CK(clk),
    .D(_001_),
    .Q(lwr_state_r[1]),
    .QN(_151_),
    .RN(rst_n)
  );
  DFFR_X1 _370_ (
    .CK(clk),
    .D(_002_),
    .Q(lwr_state_r[2]),
    .QN(_146_),
    .RN(rst_n)
  );
  axil_to_apb u_bridge (
    .clk(clk),
    .paddr(apb_paddr),
    .penable(apb_penable),
    .prdata(apb_prdata),
    .pready(apb_pready),
    .psel(apb_psel),
    .pslverr(apb_pslverr),
    .pwdata(apb_pwdata),
    .pwrite(apb_pwrite),
    .rst_n(rst_n),
    .s_araddr(s_araddr),
    .s_arready(fwd_arready),
    .s_arvalid(fwd_arvalid),
    .s_awaddr(s_awaddr),
    .s_awready(fwd_awready),
    .s_awvalid(fwd_awvalid),
    .s_bready(s_bready),
    .s_bresp(fwd_bresp),
    .s_bvalid(fwd_bvalid),
    .s_rdata(fwd_rdata),
    .s_rready(s_rready),
    .s_rresp(fwd_rresp),
    .s_rvalid(fwd_rvalid),
    .s_wdata(s_wdata),
    .s_wready(fwd_wready),
    .s_wstrb(s_wstrb),
    .s_wvalid(fwd_wvalid)
  );
  \$paramod$83bc75265b358b15e6cbe03cbfc629e968b46589\apb_spi_master  u_spi (
    .HCLK(clk),
    .HRESETn(rst_n),
    .PADDR(apb_paddr),
    .PENABLE(apb_penable),
    .PRDATA(apb_prdata),
    .PREADY(apb_pready),
    .PSEL(apb_psel),
    .PSLVERR(apb_pslverr),
    .PWDATA({ apb_pwdata[31:8], pwdata_gated[7:0] }),
    .PWRITE(apb_pwrite),
    .events_o(events_raw),
    .spi_clk(spi_sck_raw),
    .spi_csn0(spi_csn_raw[0]),
    .spi_csn1(spi_csn_raw[1]),
    .spi_csn2(spi_csn_raw[2]),
    .spi_csn3(spi_csn_raw[3]),
    .spi_mode(spi_mode_nc),
    .spi_sdi0(spi_miso),
    .spi_sdi1(1'h0),
    .spi_sdi2(1'h0),
    .spi_sdi3(1'h0),
    .spi_sdo0(spi_mosi_raw)
  );
  assign pwdata_gated[31:8] = apb_pwdata[31:8];
  assign lrd_rdata_r[31:8] = 24'h000000;
  assign irq = events_raw[1];
endmodule

module spi_master_clkgen(clk, rstn, en, clk_div, clk_div_valid, spi_clk, spi_fall, spi_rise);
  input clk;
  wire clk;
  input rstn;
  wire rstn;
  input en;
  wire en;
  input [7:0] clk_div;
  wire [7:0] clk_div;
  input clk_div_valid;
  wire clk_div_valid;
  output spi_clk;
  wire spi_clk;
  output spi_fall;
  wire spi_fall;
  output spi_rise;
  wire spi_rise;
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
  wire [7:0] counter;
  wire [7:0] counter_trgt;
  wire running;
  INV_X1 _071_ (
    .A(spi_clk),
    .ZN(_020_)
  );
  INV_X1 _072_ (
    .A(counter[2]),
    .ZN(_021_)
  );
  INV_X1 _073_ (
    .A(counter[3]),
    .ZN(_022_)
  );
  INV_X1 _074_ (
    .A(counter[4]),
    .ZN(_023_)
  );
  INV_X1 _075_ (
    .A(counter[5]),
    .ZN(_024_)
  );
  INV_X1 _076_ (
    .A(counter_trgt[4]),
    .ZN(_025_)
  );
  INV_X1 _077_ (
    .A(counter_trgt[5]),
    .ZN(_026_)
  );
  INV_X1 _078_ (
    .A(_001_),
    .ZN(_027_)
  );
  XNOR2_X1 _079_ (
    .A(counter[3]),
    .B(counter_trgt[3]),
    .ZN(_028_)
  );
  XNOR2_X1 _080_ (
    .A(counter[6]),
    .B(counter_trgt[6]),
    .ZN(_029_)
  );
  XNOR2_X1 _081_ (
    .A(counter[2]),
    .B(counter_trgt[2]),
    .ZN(_030_)
  );
  XNOR2_X1 _082_ (
    .A(counter[7]),
    .B(counter_trgt[7]),
    .ZN(_031_)
  );
  XNOR2_X1 _083_ (
    .A(counter[1]),
    .B(counter_trgt[1]),
    .ZN(_032_)
  );
  XNOR2_X1 _084_ (
    .A(counter[0]),
    .B(counter_trgt[0]),
    .ZN(_033_)
  );
  OAI221_X1 _085_ (
    .A(_030_),
    .B1(counter_trgt[5]),
    .B2(_024_),
    .C1(_023_),
    .C2(counter_trgt[4]),
    .ZN(_034_)
  );
  NAND4_X1 _086_ (
    .A1(_028_),
    .A2(_029_),
    .A3(_031_),
    .A4(_032_),
    .ZN(_035_)
  );
  OAI221_X1 _087_ (
    .A(_033_),
    .B1(_026_),
    .B2(counter[5]),
    .C1(counter[4]),
    .C2(_025_),
    .ZN(_036_)
  );
  NOR3_X1 _088_ (
    .A1(_034_),
    .A2(_035_),
    .A3(_036_),
    .ZN(_037_)
  );
  NAND2_X1 _089_ (
    .A1(running),
    .A2(_037_),
    .ZN(_038_)
  );
  NOR2_X1 _090_ (
    .A1(_020_),
    .A2(_038_),
    .ZN(spi_fall)
  );
  OR2_X1 _091_ (
    .A1(spi_clk),
    .A2(en),
    .ZN(_000_)
  );
  NOR2_X1 _092_ (
    .A1(_027_),
    .A2(_038_),
    .ZN(spi_rise)
  );
  MUX2_X1 _093_ (
    .A(counter_trgt[2]),
    .B(clk_div[2]),
    .S(clk_div_valid),
    .Z(_003_)
  );
  MUX2_X1 _094_ (
    .A(counter_trgt[1]),
    .B(clk_div[1]),
    .S(clk_div_valid),
    .Z(_004_)
  );
  MUX2_X1 _095_ (
    .A(counter_trgt[0]),
    .B(clk_div[0]),
    .S(clk_div_valid),
    .Z(_005_)
  );
  AND3_X1 _096_ (
    .A1(counter[0]),
    .A2(counter[1]),
    .A3(_000_),
    .ZN(_039_)
  );
  OAI211_X1 _097_ (
    .A(counter[0]),
    .B(counter[1]),
    .C1(en),
    .C2(spi_clk),
    .ZN(_040_)
  );
  NOR3_X1 _098_ (
    .A1(_021_),
    .A2(_022_),
    .A3(_040_),
    .ZN(_041_)
  );
  NOR4_X1 _099_ (
    .A1(_021_),
    .A2(_022_),
    .A3(_023_),
    .A4(_040_),
    .ZN(_042_)
  );
  AND2_X1 _100_ (
    .A1(counter[5]),
    .A2(_042_),
    .ZN(_043_)
  );
  NAND3_X1 _101_ (
    .A1(counter[5]),
    .A2(counter[6]),
    .A3(_042_),
    .ZN(_044_)
  );
  AND2_X1 _102_ (
    .A1(_037_),
    .A2(_000_),
    .ZN(_045_)
  );
  NAND2_X1 _103_ (
    .A1(_037_),
    .A2(_000_),
    .ZN(_046_)
  );
  OR2_X1 _104_ (
    .A1(counter[6]),
    .A2(_043_),
    .ZN(_047_)
  );
  AND3_X1 _105_ (
    .A1(_044_),
    .A2(_046_),
    .A3(_047_),
    .ZN(_006_)
  );
  NOR2_X1 _106_ (
    .A1(counter[5]),
    .A2(_042_),
    .ZN(_048_)
  );
  NOR3_X1 _107_ (
    .A1(_043_),
    .A2(_045_),
    .A3(_048_),
    .ZN(_007_)
  );
  NOR2_X1 _108_ (
    .A1(counter[4]),
    .A2(_041_),
    .ZN(_049_)
  );
  NOR3_X1 _109_ (
    .A1(_042_),
    .A2(_045_),
    .A3(_049_),
    .ZN(_008_)
  );
  AOI21_X1 _110_ (
    .A(counter[3]),
    .B1(_039_),
    .B2(counter[2]),
    .ZN(_050_)
  );
  NOR3_X1 _111_ (
    .A1(_041_),
    .A2(_045_),
    .A3(_050_),
    .ZN(_009_)
  );
  XNOR2_X1 _112_ (
    .A(_021_),
    .B(_040_),
    .ZN(_051_)
  );
  NOR2_X1 _113_ (
    .A1(_045_),
    .A2(_051_),
    .ZN(_010_)
  );
  AOI21_X1 _114_ (
    .A(counter[1]),
    .B1(_000_),
    .B2(counter[0]),
    .ZN(_052_)
  );
  NOR3_X1 _115_ (
    .A1(_039_),
    .A2(_045_),
    .A3(_052_),
    .ZN(_011_)
  );
  XOR2_X1 _116_ (
    .A(counter[7]),
    .B(_044_),
    .Z(_053_)
  );
  NOR2_X1 _117_ (
    .A1(_045_),
    .A2(_053_),
    .ZN(_012_)
  );
  MUX2_X1 _118_ (
    .A(counter[0]),
    .B(_002_),
    .S(_000_),
    .Z(_054_)
  );
  AND2_X1 _119_ (
    .A1(_046_),
    .A2(_054_),
    .ZN(_013_)
  );
  MUX2_X1 _120_ (
    .A(counter_trgt[6]),
    .B(clk_div[6]),
    .S(clk_div_valid),
    .Z(_014_)
  );
  MUX2_X1 _121_ (
    .A(counter_trgt[5]),
    .B(clk_div[5]),
    .S(clk_div_valid),
    .Z(_015_)
  );
  OAI22_X1 _122_ (
    .A1(_020_),
    .A2(_037_),
    .B1(_046_),
    .B2(_027_),
    .ZN(_016_)
  );
  MUX2_X1 _123_ (
    .A(counter_trgt[4]),
    .B(clk_div[4]),
    .S(clk_div_valid),
    .Z(_017_)
  );
  MUX2_X1 _124_ (
    .A(counter_trgt[7]),
    .B(clk_div[7]),
    .S(clk_div_valid),
    .Z(_018_)
  );
  MUX2_X1 _125_ (
    .A(counter_trgt[3]),
    .B(clk_div[3]),
    .S(clk_div_valid),
    .Z(_019_)
  );
  DFFR_X1 _126_ (
    .CK(clk),
    .D(_013_),
    .Q(counter[0]),
    .QN(_002_),
    .RN(rstn)
  );
  DFFR_X1 _127_ (
    .CK(clk),
    .D(_011_),
    .Q(counter[1]),
    .QN(_061_),
    .RN(rstn)
  );
  DFFR_X1 _128_ (
    .CK(clk),
    .D(_010_),
    .Q(counter[2]),
    .QN(_062_),
    .RN(rstn)
  );
  DFFR_X1 _129_ (
    .CK(clk),
    .D(_009_),
    .Q(counter[3]),
    .QN(_063_),
    .RN(rstn)
  );
  DFFR_X1 _130_ (
    .CK(clk),
    .D(_008_),
    .Q(counter[4]),
    .QN(_064_),
    .RN(rstn)
  );
  DFFR_X1 _131_ (
    .CK(clk),
    .D(_007_),
    .Q(counter[5]),
    .QN(_065_),
    .RN(rstn)
  );
  DFFR_X1 _132_ (
    .CK(clk),
    .D(_006_),
    .Q(counter[6]),
    .QN(_066_),
    .RN(rstn)
  );
  DFFR_X1 _133_ (
    .CK(clk),
    .D(_012_),
    .Q(counter[7]),
    .QN(_060_),
    .RN(rstn)
  );
  DFFR_X1 _134_ (
    .CK(clk),
    .D(_016_),
    .Q(spi_clk),
    .QN(_001_),
    .RN(rstn)
  );
  DFFR_X1 _135_ (
    .CK(clk),
    .D(_005_),
    .Q(counter_trgt[0]),
    .QN(_067_),
    .RN(rstn)
  );
  DFFR_X1 _136_ (
    .CK(clk),
    .D(_004_),
    .Q(counter_trgt[1]),
    .QN(_068_),
    .RN(rstn)
  );
  DFFR_X1 _137_ (
    .CK(clk),
    .D(_003_),
    .Q(counter_trgt[2]),
    .QN(_069_),
    .RN(rstn)
  );
  DFFR_X1 _138_ (
    .CK(clk),
    .D(_019_),
    .Q(counter_trgt[3]),
    .QN(_055_),
    .RN(rstn)
  );
  DFFR_X1 _139_ (
    .CK(clk),
    .D(_017_),
    .Q(counter_trgt[4]),
    .QN(_057_),
    .RN(rstn)
  );
  DFFR_X1 _140_ (
    .CK(clk),
    .D(_015_),
    .Q(counter_trgt[5]),
    .QN(_058_),
    .RN(rstn)
  );
  DFFR_X1 _141_ (
    .CK(clk),
    .D(_014_),
    .Q(counter_trgt[6]),
    .QN(_059_),
    .RN(rstn)
  );
  DFFR_X1 _142_ (
    .CK(clk),
    .D(_018_),
    .Q(counter_trgt[7]),
    .QN(_070_),
    .RN(rstn)
  );
  DFFR_X1 _143_ (
    .CK(clk),
    .D(_000_),
    .Q(running),
    .QN(_056_),
    .RN(rstn)
  );
endmodule

module spi_master_controller(clk, rstn, eot, spi_clk_div, spi_clk_div_valid, spi_status, spi_addr, spi_addr_len, spi_cmd, spi_cmd_len, spi_data_len, spi_dummy_rd, spi_dummy_wr, spi_csreg, spi_swrst, spi_rd, spi_wr, spi_qrd, spi_qwr, spi_ctrl_data_tx, spi_ctrl_data_tx_valid
, spi_ctrl_data_tx_ready, spi_ctrl_data_rx, spi_ctrl_data_rx_valid, spi_ctrl_data_rx_ready, spi_clk, spi_csn0, spi_csn1, spi_csn2, spi_csn3, spi_mode, spi_sdo0, spi_sdo1, spi_sdo2, spi_sdo3, spi_sdi0, spi_sdi1, spi_sdi2, spi_sdi3);
  input clk;
  wire clk;
  input rstn;
  wire rstn;
  output eot;
  wire eot;
  input [7:0] spi_clk_div;
  wire [7:0] spi_clk_div;
  input spi_clk_div_valid;
  wire spi_clk_div_valid;
  output [6:0] spi_status;
  wire [6:0] spi_status;
  input [31:0] spi_addr;
  wire [31:0] spi_addr;
  input [5:0] spi_addr_len;
  wire [5:0] spi_addr_len;
  input [31:0] spi_cmd;
  wire [31:0] spi_cmd;
  input [5:0] spi_cmd_len;
  wire [5:0] spi_cmd_len;
  input [15:0] spi_data_len;
  wire [15:0] spi_data_len;
  input [15:0] spi_dummy_rd;
  wire [15:0] spi_dummy_rd;
  input [15:0] spi_dummy_wr;
  wire [15:0] spi_dummy_wr;
  input [3:0] spi_csreg;
  wire [3:0] spi_csreg;
  input spi_swrst;
  wire spi_swrst;
  input spi_rd;
  wire spi_rd;
  input spi_wr;
  wire spi_wr;
  input spi_qrd;
  wire spi_qrd;
  input spi_qwr;
  wire spi_qwr;
  input [31:0] spi_ctrl_data_tx;
  wire [31:0] spi_ctrl_data_tx;
  input spi_ctrl_data_tx_valid;
  wire spi_ctrl_data_tx_valid;
  output spi_ctrl_data_tx_ready;
  wire spi_ctrl_data_tx_ready;
  output [31:0] spi_ctrl_data_rx;
  wire [31:0] spi_ctrl_data_rx;
  output spi_ctrl_data_rx_valid;
  wire spi_ctrl_data_rx_valid;
  input spi_ctrl_data_rx_ready;
  wire spi_ctrl_data_rx_ready;
  output spi_clk;
  wire spi_clk;
  output spi_csn0;
  wire spi_csn0;
  output spi_csn1;
  wire spi_csn1;
  output spi_csn2;
  wire spi_csn2;
  output spi_csn3;
  wire spi_csn3;
  output [1:0] spi_mode;
  wire [1:0] spi_mode;
  output spi_sdo0;
  wire spi_sdo0;
  output spi_sdo1;
  wire spi_sdo1;
  output spi_sdo2;
  wire spi_sdo2;
  output spi_sdo3;
  wire spi_sdo3;
  input spi_sdi0;
  wire spi_sdi0;
  input spi_sdi1;
  wire spi_sdi1;
  input spi_sdi2;
  wire spi_sdi2;
  input spi_sdi3;
  wire spi_sdi3;
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
  wire _201_;
  wire _202_;
  wire _203_;
  wire _204_;
  wire _205_;
  wire _206_;
  wire _207_;
  wire _208_;
  wire _209_;
  wire _210_;
  wire _211_;
  wire _212_;
  wire _213_;
  wire _214_;
  wire _215_;
  wire _216_;
  wire _217_;
  wire _218_;
  wire _219_;
  wire _220_;
  wire _221_;
  wire _222_;
  wire _223_;
  wire _224_;
  wire _225_;
  wire _226_;
  wire _227_;
  wire _228_;
  wire _229_;
  wire _230_;
  wire _231_;
  wire _232_;
  wire _233_;
  wire _234_;
  wire _235_;
  wire _236_;
  wire _237_;
  wire _238_;
  wire _239_;
  wire _240_;
  wire _241_;
  wire _242_;
  wire _243_;
  wire _244_;
  wire _245_;
  wire _246_;
  wire _247_;
  wire _248_;
  wire _249_;
  wire _250_;
  wire _251_;
  wire _252_;
  wire _253_;
  wire _254_;
  wire _255_;
  wire _256_;
  wire _257_;
  wire _258_;
  wire _259_;
  wire _260_;
  wire _261_;
  wire _262_;
  wire _263_;
  wire _264_;
  wire _265_;
  wire _266_;
  wire _267_;
  wire _268_;
  wire _269_;
  wire _270_;
  wire _271_;
  wire _272_;
  wire _273_;
  wire _274_;
  wire _275_;
  wire _276_;
  wire _277_;
  wire _278_;
  wire _279_;
  wire _280_;
  wire _281_;
  wire _282_;
  wire _283_;
  wire _284_;
  wire _285_;
  wire _286_;
  wire _287_;
  wire _288_;
  wire _289_;
  wire _290_;
  wire _291_;
  wire _292_;
  wire _293_;
  wire _294_;
  wire _295_;
  wire _296_;
  wire _297_;
  wire _298_;
  wire _299_;
  wire _300_;
  wire _301_;
  wire _302_;
  wire _303_;
  wire _304_;
  wire _305_;
  wire _306_;
  wire _307_;
  wire _308_;
  wire _309_;
  wire _310_;
  wire _311_;
  wire _312_;
  wire _313_;
  wire _314_;
  wire _315_;
  wire _316_;
  wire _317_;
  wire _318_;
  wire _319_;
  wire _320_;
  wire _321_;
  wire _322_;
  wire _323_;
  wire _324_;
  wire _325_;
  wire _326_;
  wire _327_;
  wire _328_;
  wire _329_;
  wire _330_;
  wire _331_;
  wire [15:0] counter_rx;
  wire counter_rx_valid;
  wire [15:0] counter_tx;
  wire counter_tx_valid;
  wire [31:0] data_to_tx;
  wire data_to_tx_ready;
  wire data_to_tx_valid;
  wire do_rx;
  wire en_quad;
  wire en_quad_int;
  wire rx_clk_en;
  wire rx_done;
  wire [1:0] s_spi_mode;
  wire spi_clock_en;
  wire spi_en_rx;
  wire spi_en_tx;
  wire spi_fall;
  wire spi_rise;
  wire [6:0] state;
  wire [4:0] state_next;
  wire tx_clk_en;
  wire tx_done;
  INV_X1 _332_ (
    .A(state[1]),
    .ZN(_009_)
  );
  INV_X1 _333_ (
    .A(tx_done),
    .ZN(_010_)
  );
  INV_X1 _334_ (
    .A(_006_),
    .ZN(_011_)
  );
  INV_X1 _335_ (
    .A(state[0]),
    .ZN(_012_)
  );
  INV_X1 _336_ (
    .A(do_rx),
    .ZN(_013_)
  );
  INV_X1 _337_ (
    .A(state[5]),
    .ZN(_014_)
  );
  INV_X1 _338_ (
    .A(spi_cmd[30]),
    .ZN(_015_)
  );
  INV_X1 _339_ (
    .A(spi_ctrl_data_tx[30]),
    .ZN(_016_)
  );
  INV_X1 _340_ (
    .A(spi_addr[30]),
    .ZN(_017_)
  );
  INV_X1 _341_ (
    .A(spi_cmd[29]),
    .ZN(_018_)
  );
  INV_X1 _342_ (
    .A(spi_ctrl_data_tx[29]),
    .ZN(_019_)
  );
  INV_X1 _343_ (
    .A(spi_addr[29]),
    .ZN(_020_)
  );
  INV_X1 _344_ (
    .A(spi_cmd[28]),
    .ZN(_021_)
  );
  INV_X1 _345_ (
    .A(spi_ctrl_data_tx[28]),
    .ZN(_022_)
  );
  INV_X1 _346_ (
    .A(spi_addr[28]),
    .ZN(_023_)
  );
  INV_X1 _347_ (
    .A(spi_ctrl_data_tx[27]),
    .ZN(_024_)
  );
  INV_X1 _348_ (
    .A(spi_cmd[27]),
    .ZN(_025_)
  );
  INV_X1 _349_ (
    .A(spi_addr[27]),
    .ZN(_026_)
  );
  INV_X1 _350_ (
    .A(spi_cmd[26]),
    .ZN(_027_)
  );
  INV_X1 _351_ (
    .A(spi_ctrl_data_tx[26]),
    .ZN(_028_)
  );
  INV_X1 _352_ (
    .A(spi_addr[26]),
    .ZN(_029_)
  );
  INV_X1 _353_ (
    .A(spi_ctrl_data_tx[25]),
    .ZN(_030_)
  );
  INV_X1 _354_ (
    .A(spi_cmd[25]),
    .ZN(_031_)
  );
  INV_X1 _355_ (
    .A(spi_addr[25]),
    .ZN(_032_)
  );
  INV_X1 _356_ (
    .A(spi_ctrl_data_tx[24]),
    .ZN(_033_)
  );
  INV_X1 _357_ (
    .A(spi_cmd[24]),
    .ZN(_034_)
  );
  INV_X1 _358_ (
    .A(spi_addr[24]),
    .ZN(_035_)
  );
  INV_X1 _359_ (
    .A(spi_ctrl_data_tx[23]),
    .ZN(_036_)
  );
  INV_X1 _360_ (
    .A(spi_cmd[23]),
    .ZN(_037_)
  );
  INV_X1 _361_ (
    .A(spi_addr[23]),
    .ZN(_038_)
  );
  INV_X1 _362_ (
    .A(spi_ctrl_data_tx[22]),
    .ZN(_039_)
  );
  INV_X1 _363_ (
    .A(spi_cmd[22]),
    .ZN(_040_)
  );
  INV_X1 _364_ (
    .A(spi_addr[22]),
    .ZN(_041_)
  );
  INV_X1 _365_ (
    .A(spi_ctrl_data_tx[21]),
    .ZN(_042_)
  );
  INV_X1 _366_ (
    .A(spi_cmd[21]),
    .ZN(_043_)
  );
  INV_X1 _367_ (
    .A(spi_addr[21]),
    .ZN(_044_)
  );
  INV_X1 _368_ (
    .A(spi_cmd[20]),
    .ZN(_045_)
  );
  INV_X1 _369_ (
    .A(spi_ctrl_data_tx[20]),
    .ZN(_046_)
  );
  INV_X1 _370_ (
    .A(spi_addr[20]),
    .ZN(_047_)
  );
  INV_X1 _371_ (
    .A(spi_cmd[19]),
    .ZN(_048_)
  );
  INV_X1 _372_ (
    .A(spi_ctrl_data_tx[19]),
    .ZN(_049_)
  );
  INV_X1 _373_ (
    .A(spi_addr[19]),
    .ZN(_050_)
  );
  INV_X1 _374_ (
    .A(spi_ctrl_data_tx[18]),
    .ZN(_051_)
  );
  INV_X1 _375_ (
    .A(spi_cmd[18]),
    .ZN(_052_)
  );
  INV_X1 _376_ (
    .A(spi_addr[18]),
    .ZN(_053_)
  );
  INV_X1 _377_ (
    .A(spi_ctrl_data_tx[17]),
    .ZN(_054_)
  );
  INV_X1 _378_ (
    .A(spi_cmd[17]),
    .ZN(_055_)
  );
  INV_X1 _379_ (
    .A(spi_addr[17]),
    .ZN(_056_)
  );
  INV_X1 _380_ (
    .A(spi_ctrl_data_tx[16]),
    .ZN(_057_)
  );
  INV_X1 _381_ (
    .A(spi_cmd[16]),
    .ZN(_058_)
  );
  INV_X1 _382_ (
    .A(spi_addr[16]),
    .ZN(_059_)
  );
  INV_X1 _383_ (
    .A(spi_ctrl_data_tx[15]),
    .ZN(_060_)
  );
  INV_X1 _384_ (
    .A(spi_cmd[15]),
    .ZN(_061_)
  );
  INV_X1 _385_ (
    .A(spi_addr[15]),
    .ZN(_062_)
  );
  INV_X1 _386_ (
    .A(spi_ctrl_data_tx[14]),
    .ZN(_063_)
  );
  INV_X1 _387_ (
    .A(spi_cmd[14]),
    .ZN(_064_)
  );
  INV_X1 _388_ (
    .A(spi_addr[14]),
    .ZN(_065_)
  );
  INV_X1 _389_ (
    .A(spi_cmd[13]),
    .ZN(_066_)
  );
  INV_X1 _390_ (
    .A(spi_ctrl_data_tx[13]),
    .ZN(_067_)
  );
  INV_X1 _391_ (
    .A(spi_addr[13]),
    .ZN(_068_)
  );
  INV_X1 _392_ (
    .A(spi_ctrl_data_tx[12]),
    .ZN(_069_)
  );
  INV_X1 _393_ (
    .A(spi_cmd[12]),
    .ZN(_070_)
  );
  INV_X1 _394_ (
    .A(spi_addr[12]),
    .ZN(_071_)
  );
  INV_X1 _395_ (
    .A(spi_ctrl_data_tx[11]),
    .ZN(_072_)
  );
  INV_X1 _396_ (
    .A(spi_cmd[11]),
    .ZN(_073_)
  );
  INV_X1 _397_ (
    .A(spi_addr[11]),
    .ZN(_074_)
  );
  INV_X1 _398_ (
    .A(spi_cmd[10]),
    .ZN(_075_)
  );
  INV_X1 _399_ (
    .A(spi_ctrl_data_tx[10]),
    .ZN(_076_)
  );
  INV_X1 _400_ (
    .A(spi_addr[10]),
    .ZN(_077_)
  );
  INV_X1 _401_ (
    .A(spi_ctrl_data_tx[9]),
    .ZN(_078_)
  );
  INV_X1 _402_ (
    .A(spi_cmd[9]),
    .ZN(_079_)
  );
  INV_X1 _403_ (
    .A(spi_addr[9]),
    .ZN(_080_)
  );
  INV_X1 _404_ (
    .A(spi_ctrl_data_tx[8]),
    .ZN(_081_)
  );
  INV_X1 _405_ (
    .A(spi_cmd[8]),
    .ZN(_082_)
  );
  INV_X1 _406_ (
    .A(spi_addr[8]),
    .ZN(_083_)
  );
  INV_X1 _407_ (
    .A(spi_cmd[7]),
    .ZN(_084_)
  );
  INV_X1 _408_ (
    .A(spi_ctrl_data_tx[7]),
    .ZN(_085_)
  );
  INV_X1 _409_ (
    .A(spi_addr[7]),
    .ZN(_086_)
  );
  INV_X1 _410_ (
    .A(spi_ctrl_data_tx[6]),
    .ZN(_087_)
  );
  INV_X1 _411_ (
    .A(spi_cmd[6]),
    .ZN(_088_)
  );
  INV_X1 _412_ (
    .A(spi_addr[6]),
    .ZN(_089_)
  );
  INV_X1 _413_ (
    .A(spi_cmd[5]),
    .ZN(_090_)
  );
  INV_X1 _414_ (
    .A(spi_ctrl_data_tx[5]),
    .ZN(_091_)
  );
  INV_X1 _415_ (
    .A(spi_addr[5]),
    .ZN(_092_)
  );
  INV_X1 _416_ (
    .A(spi_cmd[4]),
    .ZN(_093_)
  );
  INV_X1 _417_ (
    .A(spi_ctrl_data_tx[4]),
    .ZN(_094_)
  );
  INV_X1 _418_ (
    .A(spi_addr[4]),
    .ZN(_095_)
  );
  INV_X1 _419_ (
    .A(spi_cmd[3]),
    .ZN(_096_)
  );
  INV_X1 _420_ (
    .A(spi_ctrl_data_tx[3]),
    .ZN(_097_)
  );
  INV_X1 _421_ (
    .A(spi_addr[3]),
    .ZN(_098_)
  );
  INV_X1 _422_ (
    .A(spi_ctrl_data_tx[2]),
    .ZN(_099_)
  );
  INV_X1 _423_ (
    .A(spi_cmd[2]),
    .ZN(_100_)
  );
  INV_X1 _424_ (
    .A(spi_addr[2]),
    .ZN(_101_)
  );
  INV_X1 _425_ (
    .A(spi_ctrl_data_tx[1]),
    .ZN(_102_)
  );
  INV_X1 _426_ (
    .A(spi_cmd[1]),
    .ZN(_103_)
  );
  INV_X1 _427_ (
    .A(spi_addr[1]),
    .ZN(_104_)
  );
  INV_X1 _428_ (
    .A(spi_ctrl_data_tx[0]),
    .ZN(_105_)
  );
  INV_X1 _429_ (
    .A(spi_cmd[0]),
    .ZN(_106_)
  );
  INV_X1 _430_ (
    .A(spi_addr[0]),
    .ZN(_107_)
  );
  INV_X1 _431_ (
    .A(spi_cmd[31]),
    .ZN(_108_)
  );
  INV_X1 _432_ (
    .A(spi_ctrl_data_tx[31]),
    .ZN(_109_)
  );
  INV_X1 _433_ (
    .A(spi_addr[31]),
    .ZN(_110_)
  );
  INV_X1 _434_ (
    .A(spi_ctrl_data_tx_valid),
    .ZN(_111_)
  );
  INV_X1 _435_ (
    .A(state[6]),
    .ZN(_112_)
  );
  INV_X1 _436_ (
    .A(state[3]),
    .ZN(_113_)
  );
  INV_X1 _437_ (
    .A(rx_done),
    .ZN(_114_)
  );
  INV_X1 _438_ (
    .A(data_to_tx_ready),
    .ZN(_115_)
  );
  NOR2_X1 _439_ (
    .A1(spi_qrd),
    .A2(spi_qwr),
    .ZN(_116_)
  );
  NOR3_X1 _440_ (
    .A1(spi_qrd),
    .A2(spi_qwr),
    .A3(en_quad_int),
    .ZN(_117_)
  );
  INV_X1 _441_ (
    .A(_117_),
    .ZN(en_quad)
  );
  NAND2_X1 _442_ (
    .A1(state[1]),
    .A2(tx_done),
    .ZN(_118_)
  );
  NOR2_X1 _443_ (
    .A1(_011_),
    .A2(_118_),
    .ZN(_119_)
  );
  NOR2_X1 _444_ (
    .A1(spi_addr_len[5]),
    .A2(spi_addr_len[4]),
    .ZN(_120_)
  );
  NOR4_X1 _445_ (
    .A1(spi_addr_len[3]),
    .A2(spi_addr_len[2]),
    .A3(spi_addr_len[1]),
    .A4(spi_addr_len[0]),
    .ZN(_121_)
  );
  AND2_X1 _446_ (
    .A1(_120_),
    .A2(_121_),
    .ZN(_122_)
  );
  NAND2_X1 _447_ (
    .A1(_120_),
    .A2(_121_),
    .ZN(_123_)
  );
  AOI21_X1 _448_ (
    .A(state[2]),
    .B1(_120_),
    .B2(_121_),
    .ZN(_124_)
  );
  OR2_X1 _449_ (
    .A1(state[2]),
    .A2(state[4]),
    .ZN(_125_)
  );
  NAND2_X1 _450_ (
    .A1(tx_done),
    .A2(_125_),
    .ZN(_126_)
  );
  OR2_X1 _451_ (
    .A1(_124_),
    .A2(_126_),
    .ZN(_127_)
  );
  NOR4_X1 _452_ (
    .A1(spi_data_len[14]),
    .A2(spi_data_len[13]),
    .A3(spi_data_len[12]),
    .A4(spi_data_len[11]),
    .ZN(_128_)
  );
  NOR4_X1 _453_ (
    .A1(spi_data_len[9]),
    .A2(spi_data_len[8]),
    .A3(spi_data_len[10]),
    .A4(spi_data_len[7]),
    .ZN(_129_)
  );
  NOR4_X1 _454_ (
    .A1(spi_data_len[6]),
    .A2(spi_data_len[5]),
    .A3(spi_data_len[4]),
    .A4(spi_data_len[3]),
    .ZN(_130_)
  );
  NOR4_X1 _455_ (
    .A1(spi_data_len[0]),
    .A2(spi_data_len[15]),
    .A3(spi_data_len[2]),
    .A4(spi_data_len[1]),
    .ZN(_131_)
  );
  AND4_X1 _456_ (
    .A1(_128_),
    .A2(_129_),
    .A3(_130_),
    .A4(_131_),
    .ZN(_132_)
  );
  NAND4_X1 _457_ (
    .A1(_128_),
    .A2(_129_),
    .A3(_130_),
    .A4(_131_),
    .ZN(_133_)
  );
  NOR2_X1 _458_ (
    .A1(_011_),
    .A2(_132_),
    .ZN(_134_)
  );
  NOR3_X1 _459_ (
    .A1(_124_),
    .A2(_126_),
    .A3(_132_),
    .ZN(_135_)
  );
  NOR4_X1 _460_ (
    .A1(_011_),
    .A2(_124_),
    .A3(_126_),
    .A4(_132_),
    .ZN(_136_)
  );
  NAND2_X1 _461_ (
    .A1(_006_),
    .A2(_135_),
    .ZN(_137_)
  );
  NOR2_X1 _462_ (
    .A1(spi_rd),
    .A2(spi_qrd),
    .ZN(_138_)
  );
  OR2_X1 _463_ (
    .A1(spi_rd),
    .A2(spi_qrd),
    .ZN(_139_)
  );
  NOR2_X1 _464_ (
    .A1(spi_cmd_len[2]),
    .A2(spi_cmd_len[1]),
    .ZN(_140_)
  );
  NOR4_X1 _465_ (
    .A1(spi_cmd_len[5]),
    .A2(spi_cmd_len[4]),
    .A3(spi_cmd_len[3]),
    .A4(spi_cmd_len[0]),
    .ZN(_141_)
  );
  AND2_X1 _466_ (
    .A1(_140_),
    .A2(_141_),
    .ZN(_142_)
  );
  AND2_X1 _467_ (
    .A1(_122_),
    .A2(_142_),
    .ZN(_143_)
  );
  NAND2_X1 _468_ (
    .A1(_122_),
    .A2(_142_),
    .ZN(_144_)
  );
  NOR3_X1 _469_ (
    .A1(spi_qwr),
    .A2(spi_wr),
    .A3(_139_),
    .ZN(_145_)
  );
  OR4_X1 _470_ (
    .A1(spi_rd),
    .A2(spi_qrd),
    .A3(spi_qwr),
    .A4(spi_wr),
    .ZN(_146_)
  );
  AND2_X1 _471_ (
    .A1(state[0]),
    .A2(_146_),
    .ZN(_147_)
  );
  NAND2_X1 _472_ (
    .A1(state[0]),
    .A2(_146_),
    .ZN(_148_)
  );
  NAND2_X1 _473_ (
    .A1(_133_),
    .A2(_147_),
    .ZN(_149_)
  );
  NAND4_X1 _474_ (
    .A1(state[0]),
    .A2(_140_),
    .A3(_141_),
    .A4(_146_),
    .ZN(_150_)
  );
  NOR4_X1 _475_ (
    .A1(_123_),
    .A2(_132_),
    .A3(_139_),
    .A4(_150_),
    .ZN(_151_)
  );
  OR2_X1 _476_ (
    .A1(_136_),
    .A2(_151_),
    .ZN(_152_)
  );
  NOR4_X1 _477_ (
    .A1(spi_dummy_wr[6]),
    .A2(spi_dummy_wr[5]),
    .A3(spi_dummy_wr[4]),
    .A4(spi_dummy_wr[3]),
    .ZN(_153_)
  );
  NOR2_X1 _478_ (
    .A1(spi_dummy_wr[2]),
    .A2(spi_dummy_wr[15]),
    .ZN(_154_)
  );
  NAND2_X1 _479_ (
    .A1(_153_),
    .A2(_154_),
    .ZN(_155_)
  );
  NOR2_X1 _480_ (
    .A1(spi_dummy_wr[8]),
    .A2(spi_dummy_wr[14]),
    .ZN(_156_)
  );
  NOR4_X1 _481_ (
    .A1(spi_dummy_wr[9]),
    .A2(spi_dummy_wr[12]),
    .A3(spi_dummy_wr[13]),
    .A4(spi_dummy_wr[11]),
    .ZN(_157_)
  );
  NOR4_X1 _482_ (
    .A1(spi_dummy_wr[10]),
    .A2(spi_dummy_wr[7]),
    .A3(spi_dummy_wr[1]),
    .A4(spi_dummy_wr[0]),
    .ZN(_158_)
  );
  NAND3_X1 _483_ (
    .A1(_156_),
    .A2(_157_),
    .A3(_158_),
    .ZN(_159_)
  );
  NOR2_X1 _484_ (
    .A1(_155_),
    .A2(_159_),
    .ZN(_160_)
  );
  AND2_X1 _485_ (
    .A1(_152_),
    .A2(_160_),
    .ZN(_161_)
  );
  OAI21_X1 _486_ (
    .A(_160_),
    .B1(_151_),
    .B2(_136_),
    .ZN(_162_)
  );
  OAI21_X1 _487_ (
    .A(_162_),
    .B1(_118_),
    .B2(_011_),
    .ZN(_163_)
  );
  AND2_X1 _488_ (
    .A1(do_rx),
    .A2(_135_),
    .ZN(_164_)
  );
  OAI33_X1 _489_ (
    .A1(_013_),
    .A2(_127_),
    .A3(_132_),
    .B1(_138_),
    .B2(_144_),
    .B3(_149_),
    .ZN(_165_)
  );
  MUX2_X1 _490_ (
    .A(spi_dummy_rd[12]),
    .B(spi_dummy_rd[14]),
    .S(_117_),
    .Z(_166_)
  );
  NOR2_X1 _491_ (
    .A1(spi_dummy_wr[12]),
    .A2(_117_),
    .ZN(_167_)
  );
  OAI21_X1 _492_ (
    .A(_152_),
    .B1(en_quad),
    .B2(spi_dummy_wr[14]),
    .ZN(_168_)
  );
  AOI22_X1 _493_ (
    .A1(spi_data_len[14]),
    .A2(_163_),
    .B1(_165_),
    .B2(_166_),
    .ZN(_169_)
  );
  OAI21_X1 _494_ (
    .A(_169_),
    .B1(_168_),
    .B2(_167_),
    .ZN(counter_tx[14])
  );
  MUX2_X1 _495_ (
    .A(spi_dummy_wr[13]),
    .B(spi_dummy_wr[11]),
    .S(en_quad),
    .Z(_170_)
  );
  NOR2_X1 _496_ (
    .A1(spi_dummy_rd[11]),
    .A2(_117_),
    .ZN(_171_)
  );
  OAI21_X1 _497_ (
    .A(_165_),
    .B1(en_quad),
    .B2(spi_dummy_rd[13]),
    .ZN(_172_)
  );
  AOI22_X1 _498_ (
    .A1(spi_data_len[13]),
    .A2(_163_),
    .B1(_170_),
    .B2(_152_),
    .ZN(_173_)
  );
  OAI21_X1 _499_ (
    .A(_173_),
    .B1(_172_),
    .B2(_171_),
    .ZN(counter_tx[13])
  );
  MUX2_X1 _500_ (
    .A(spi_dummy_wr[10]),
    .B(spi_dummy_wr[12]),
    .S(_117_),
    .Z(_174_)
  );
  NOR2_X1 _501_ (
    .A1(spi_dummy_rd[10]),
    .A2(_117_),
    .ZN(_175_)
  );
  OAI21_X1 _502_ (
    .A(_165_),
    .B1(en_quad),
    .B2(spi_dummy_rd[12]),
    .ZN(_176_)
  );
  AOI22_X1 _503_ (
    .A1(spi_data_len[12]),
    .A2(_163_),
    .B1(_174_),
    .B2(_152_),
    .ZN(_177_)
  );
  OAI21_X1 _504_ (
    .A(_177_),
    .B1(_176_),
    .B2(_175_),
    .ZN(counter_tx[12])
  );
  MUX2_X1 _505_ (
    .A(spi_dummy_wr[9]),
    .B(spi_dummy_wr[11]),
    .S(_117_),
    .Z(_178_)
  );
  NOR2_X1 _506_ (
    .A1(spi_dummy_rd[9]),
    .A2(_117_),
    .ZN(_179_)
  );
  OAI21_X1 _507_ (
    .A(_165_),
    .B1(en_quad),
    .B2(spi_dummy_rd[11]),
    .ZN(_180_)
  );
  AOI22_X1 _508_ (
    .A1(spi_data_len[11]),
    .A2(_163_),
    .B1(_178_),
    .B2(_152_),
    .ZN(_181_)
  );
  OAI21_X1 _509_ (
    .A(_181_),
    .B1(_180_),
    .B2(_179_),
    .ZN(counter_tx[11])
  );
  MUX2_X1 _510_ (
    .A(spi_dummy_wr[10]),
    .B(spi_dummy_wr[8]),
    .S(en_quad),
    .Z(_182_)
  );
  NOR2_X1 _511_ (
    .A1(spi_dummy_rd[8]),
    .A2(_117_),
    .ZN(_183_)
  );
  OAI21_X1 _512_ (
    .A(_165_),
    .B1(en_quad),
    .B2(spi_dummy_rd[10]),
    .ZN(_184_)
  );
  AOI22_X1 _513_ (
    .A1(spi_data_len[10]),
    .A2(_163_),
    .B1(_182_),
    .B2(_152_),
    .ZN(_185_)
  );
  OAI21_X1 _514_ (
    .A(_185_),
    .B1(_184_),
    .B2(_183_),
    .ZN(counter_tx[10])
  );
  MUX2_X1 _515_ (
    .A(spi_dummy_wr[9]),
    .B(spi_dummy_wr[7]),
    .S(en_quad),
    .Z(_186_)
  );
  NOR2_X1 _516_ (
    .A1(spi_dummy_rd[7]),
    .A2(_117_),
    .ZN(_187_)
  );
  OAI21_X1 _517_ (
    .A(_165_),
    .B1(en_quad),
    .B2(spi_dummy_rd[9]),
    .ZN(_188_)
  );
  AOI22_X1 _518_ (
    .A1(spi_data_len[9]),
    .A2(_163_),
    .B1(_186_),
    .B2(_152_),
    .ZN(_189_)
  );
  OAI21_X1 _519_ (
    .A(_189_),
    .B1(_188_),
    .B2(_187_),
    .ZN(counter_tx[9])
  );
  MUX2_X1 _520_ (
    .A(spi_dummy_wr[8]),
    .B(spi_dummy_wr[6]),
    .S(en_quad),
    .Z(_190_)
  );
  NOR2_X1 _521_ (
    .A1(spi_dummy_rd[6]),
    .A2(_117_),
    .ZN(_191_)
  );
  OAI21_X1 _522_ (
    .A(_165_),
    .B1(en_quad),
    .B2(spi_dummy_rd[8]),
    .ZN(_192_)
  );
  AOI22_X1 _523_ (
    .A1(spi_data_len[8]),
    .A2(_163_),
    .B1(_190_),
    .B2(_152_),
    .ZN(_193_)
  );
  OAI21_X1 _524_ (
    .A(_193_),
    .B1(_192_),
    .B2(_191_),
    .ZN(counter_tx[8])
  );
  MUX2_X1 _525_ (
    .A(spi_dummy_wr[7]),
    .B(spi_dummy_wr[5]),
    .S(en_quad),
    .Z(_194_)
  );
  NOR2_X1 _526_ (
    .A1(spi_dummy_rd[5]),
    .A2(_117_),
    .ZN(_195_)
  );
  OAI21_X1 _527_ (
    .A(_165_),
    .B1(en_quad),
    .B2(spi_dummy_rd[7]),
    .ZN(_196_)
  );
  AOI22_X1 _528_ (
    .A1(spi_data_len[7]),
    .A2(_163_),
    .B1(_194_),
    .B2(_152_),
    .ZN(_197_)
  );
  OAI21_X1 _529_ (
    .A(_197_),
    .B1(_196_),
    .B2(_195_),
    .ZN(counter_tx[7])
  );
  MUX2_X1 _530_ (
    .A(spi_dummy_rd[6]),
    .B(spi_dummy_rd[4]),
    .S(en_quad),
    .Z(_198_)
  );
  NOR2_X1 _531_ (
    .A1(spi_dummy_wr[4]),
    .A2(_117_),
    .ZN(_199_)
  );
  OAI21_X1 _532_ (
    .A(_152_),
    .B1(en_quad),
    .B2(spi_dummy_wr[6]),
    .ZN(_200_)
  );
  AOI22_X1 _533_ (
    .A1(spi_data_len[6]),
    .A2(_163_),
    .B1(_165_),
    .B2(_198_),
    .ZN(_201_)
  );
  OAI21_X1 _534_ (
    .A(_201_),
    .B1(_200_),
    .B2(_199_),
    .ZN(counter_tx[6])
  );
  AND2_X1 _535_ (
    .A1(spi_dummy_wr[3]),
    .A2(en_quad),
    .ZN(_202_)
  );
  AOI221_X1 _536_ (
    .A(_202_),
    .B1(_117_),
    .B2(spi_dummy_wr[5]),
    .C1(spi_data_len[5]),
    .C2(_160_),
    .ZN(_203_)
  );
  MUX2_X1 _537_ (
    .A(spi_dummy_rd[5]),
    .B(spi_dummy_rd[3]),
    .S(en_quad),
    .Z(_204_)
  );
  NOR2_X1 _538_ (
    .A1(_138_),
    .A2(_204_),
    .ZN(_205_)
  );
  NAND2_X1 _539_ (
    .A1(_133_),
    .A2(_143_),
    .ZN(_206_)
  );
  AOI211_X1 _540_ (
    .A(_205_),
    .B(_206_),
    .C1(_138_),
    .C2(_203_),
    .ZN(_207_)
  );
  OAI21_X1 _541_ (
    .A(_147_),
    .B1(_207_),
    .B2(spi_cmd_len[5]),
    .ZN(_208_)
  );
  NAND2_X1 _542_ (
    .A1(tx_done),
    .A2(state[4]),
    .ZN(_209_)
  );
  NAND2_X1 _543_ (
    .A1(_150_),
    .A2(_209_),
    .ZN(_210_)
  );
  AOI222_X1 _544_ (
    .A1(spi_data_len[5]),
    .A2(_119_),
    .B1(_164_),
    .B2(_204_),
    .C1(_210_),
    .C2(spi_addr_len[5]),
    .ZN(_211_)
  );
  OAI211_X1 _545_ (
    .A(_208_),
    .B(_211_),
    .C1(_137_),
    .C2(_203_),
    .ZN(counter_tx[5])
  );
  AND2_X1 _546_ (
    .A1(spi_dummy_wr[2]),
    .A2(en_quad),
    .ZN(_212_)
  );
  AOI221_X1 _547_ (
    .A(_212_),
    .B1(_117_),
    .B2(spi_dummy_wr[4]),
    .C1(spi_data_len[4]),
    .C2(_160_),
    .ZN(_213_)
  );
  MUX2_X1 _548_ (
    .A(spi_dummy_rd[4]),
    .B(spi_dummy_rd[2]),
    .S(en_quad),
    .Z(_214_)
  );
  NOR2_X1 _549_ (
    .A1(_138_),
    .A2(_214_),
    .ZN(_215_)
  );
  AOI211_X1 _550_ (
    .A(_206_),
    .B(_215_),
    .C1(_213_),
    .C2(_138_),
    .ZN(_216_)
  );
  OAI21_X1 _551_ (
    .A(_147_),
    .B1(_216_),
    .B2(spi_cmd_len[4]),
    .ZN(_217_)
  );
  AOI222_X1 _552_ (
    .A1(spi_data_len[4]),
    .A2(_119_),
    .B1(_164_),
    .B2(_214_),
    .C1(_210_),
    .C2(spi_addr_len[4]),
    .ZN(_218_)
  );
  OAI211_X1 _553_ (
    .A(_217_),
    .B(_218_),
    .C1(_137_),
    .C2(_213_),
    .ZN(counter_tx[4])
  );
  NAND2_X1 _554_ (
    .A1(spi_data_len[3]),
    .A2(_163_),
    .ZN(_219_)
  );
  MUX2_X1 _555_ (
    .A(spi_dummy_wr[1]),
    .B(spi_dummy_wr[3]),
    .S(_117_),
    .Z(_220_)
  );
  NAND2_X1 _556_ (
    .A1(_152_),
    .A2(_220_),
    .ZN(_221_)
  );
  MUX2_X1 _557_ (
    .A(spi_dummy_rd[3]),
    .B(spi_dummy_rd[1]),
    .S(en_quad),
    .Z(_222_)
  );
  AOI222_X1 _558_ (
    .A1(spi_cmd_len[3]),
    .A2(_147_),
    .B1(_165_),
    .B2(_222_),
    .C1(_210_),
    .C2(spi_addr_len[3]),
    .ZN(_223_)
  );
  NAND3_X1 _559_ (
    .A1(_219_),
    .A2(_221_),
    .A3(_223_),
    .ZN(counter_tx[3])
  );
  AND2_X1 _560_ (
    .A1(spi_dummy_wr[0]),
    .A2(en_quad),
    .ZN(_224_)
  );
  AOI221_X1 _561_ (
    .A(_224_),
    .B1(_117_),
    .B2(spi_dummy_wr[2]),
    .C1(spi_data_len[2]),
    .C2(_160_),
    .ZN(_225_)
  );
  MUX2_X1 _562_ (
    .A(spi_dummy_rd[2]),
    .B(spi_dummy_rd[0]),
    .S(en_quad),
    .Z(_226_)
  );
  NOR2_X1 _563_ (
    .A1(_138_),
    .A2(_226_),
    .ZN(_227_)
  );
  AOI211_X1 _564_ (
    .A(_206_),
    .B(_227_),
    .C1(_225_),
    .C2(_138_),
    .ZN(_228_)
  );
  OAI21_X1 _565_ (
    .A(_147_),
    .B1(_228_),
    .B2(spi_cmd_len[2]),
    .ZN(_229_)
  );
  AOI22_X1 _566_ (
    .A1(spi_data_len[2]),
    .A2(_119_),
    .B1(_210_),
    .B2(spi_addr_len[2]),
    .ZN(_230_)
  );
  OAI21_X1 _567_ (
    .A(_230_),
    .B1(_225_),
    .B2(_137_),
    .ZN(_231_)
  );
  AOI21_X1 _568_ (
    .A(_231_),
    .B1(_226_),
    .B2(_164_),
    .ZN(_232_)
  );
  NAND2_X1 _569_ (
    .A1(_229_),
    .A2(_232_),
    .ZN(counter_tx[2])
  );
  AOI22_X1 _570_ (
    .A1(spi_dummy_wr[1]),
    .A2(_117_),
    .B1(_160_),
    .B2(spi_data_len[1]),
    .ZN(_233_)
  );
  AOI21_X1 _571_ (
    .A(_138_),
    .B1(_117_),
    .B2(spi_dummy_rd[1]),
    .ZN(_234_)
  );
  AOI211_X1 _572_ (
    .A(_206_),
    .B(_234_),
    .C1(_233_),
    .C2(_138_),
    .ZN(_235_)
  );
  OAI21_X1 _573_ (
    .A(_147_),
    .B1(_235_),
    .B2(spi_cmd_len[1]),
    .ZN(_236_)
  );
  NAND3_X1 _574_ (
    .A1(spi_dummy_rd[1]),
    .A2(_117_),
    .A3(_164_),
    .ZN(_237_)
  );
  NOR2_X1 _575_ (
    .A1(_137_),
    .A2(_233_),
    .ZN(_238_)
  );
  AOI221_X1 _576_ (
    .A(_238_),
    .B1(_119_),
    .B2(spi_data_len[1]),
    .C1(spi_addr_len[1]),
    .C2(_210_),
    .ZN(_239_)
  );
  NAND3_X1 _577_ (
    .A1(_236_),
    .A2(_237_),
    .A3(_239_),
    .ZN(counter_tx[1])
  );
  AOI22_X1 _578_ (
    .A1(spi_dummy_wr[0]),
    .A2(_117_),
    .B1(_160_),
    .B2(spi_data_len[0]),
    .ZN(_240_)
  );
  AOI21_X1 _579_ (
    .A(_138_),
    .B1(_117_),
    .B2(spi_dummy_rd[0]),
    .ZN(_241_)
  );
  AOI211_X1 _580_ (
    .A(_206_),
    .B(_241_),
    .C1(_240_),
    .C2(_138_),
    .ZN(_242_)
  );
  OAI21_X1 _581_ (
    .A(_147_),
    .B1(_242_),
    .B2(spi_cmd_len[0]),
    .ZN(_243_)
  );
  NAND3_X1 _582_ (
    .A1(spi_dummy_rd[0]),
    .A2(_117_),
    .A3(_164_),
    .ZN(_244_)
  );
  NOR2_X1 _583_ (
    .A1(_137_),
    .A2(_240_),
    .ZN(_245_)
  );
  AOI221_X1 _584_ (
    .A(_245_),
    .B1(_119_),
    .B2(spi_data_len[0]),
    .C1(spi_addr_len[0]),
    .C2(_210_),
    .ZN(_246_)
  );
  NAND3_X1 _585_ (
    .A1(_243_),
    .A2(_244_),
    .A3(_246_),
    .ZN(counter_tx[0])
  );
  NOR2_X1 _586_ (
    .A1(_122_),
    .A2(_209_),
    .ZN(_247_)
  );
  OR2_X1 _587_ (
    .A1(_122_),
    .A2(_209_),
    .ZN(_248_)
  );
  NOR4_X1 _588_ (
    .A1(spi_dummy_rd[10]),
    .A2(spi_dummy_rd[9]),
    .A3(spi_dummy_rd[8]),
    .A4(spi_dummy_rd[7]),
    .ZN(_249_)
  );
  NOR4_X1 _589_ (
    .A1(spi_dummy_rd[12]),
    .A2(spi_dummy_rd[14]),
    .A3(spi_dummy_rd[11]),
    .A4(spi_dummy_rd[13]),
    .ZN(_250_)
  );
  NOR4_X1 _590_ (
    .A1(spi_dummy_rd[6]),
    .A2(spi_dummy_rd[5]),
    .A3(spi_dummy_rd[4]),
    .A4(spi_dummy_rd[3]),
    .ZN(_251_)
  );
  NOR4_X1 _591_ (
    .A1(spi_dummy_rd[2]),
    .A2(spi_dummy_rd[1]),
    .A3(spi_dummy_rd[0]),
    .A4(spi_dummy_rd[15]),
    .ZN(_252_)
  );
  AND4_X1 _592_ (
    .A1(_249_),
    .A2(_250_),
    .A3(_251_),
    .A4(_252_),
    .ZN(_253_)
  );
  NAND4_X1 _593_ (
    .A1(_249_),
    .A2(_250_),
    .A3(_251_),
    .A4(_252_),
    .ZN(_254_)
  );
  NOR2_X1 _594_ (
    .A1(_006_),
    .A2(_253_),
    .ZN(_255_)
  );
  AOI211_X1 _595_ (
    .A(_155_),
    .B(_159_),
    .C1(_254_),
    .C2(_011_),
    .ZN(_256_)
  );
  NAND2_X1 _596_ (
    .A1(do_rx),
    .A2(_253_),
    .ZN(_257_)
  );
  OAI211_X1 _597_ (
    .A(tx_done),
    .B(_133_),
    .C1(_254_),
    .C2(_013_),
    .ZN(_258_)
  );
  OAI21_X1 _598_ (
    .A(_248_),
    .B1(_256_),
    .B2(_258_),
    .ZN(_259_)
  );
  NAND2_X1 _599_ (
    .A1(state[1]),
    .A2(_010_),
    .ZN(_260_)
  );
  OR2_X1 _600_ (
    .A1(_122_),
    .A2(_150_),
    .ZN(_261_)
  );
  NAND2_X1 _601_ (
    .A1(_260_),
    .A2(_261_),
    .ZN(_262_)
  );
  NOR3_X1 _602_ (
    .A1(_139_),
    .A2(_155_),
    .A3(_159_),
    .ZN(_263_)
  );
  NOR2_X1 _603_ (
    .A1(_138_),
    .A2(_254_),
    .ZN(_264_)
  );
  NAND2_X1 _604_ (
    .A1(_139_),
    .A2(_253_),
    .ZN(_265_)
  );
  NOR4_X1 _605_ (
    .A1(_144_),
    .A2(_149_),
    .A3(_263_),
    .A4(_264_),
    .ZN(_266_)
  );
  AOI211_X1 _606_ (
    .A(_262_),
    .B(_266_),
    .C1(_125_),
    .C2(_259_),
    .ZN(_267_)
  );
  AND2_X1 _607_ (
    .A1(_014_),
    .A2(_162_),
    .ZN(_268_)
  );
  NAND2_X1 _608_ (
    .A1(_144_),
    .A2(_147_),
    .ZN(_269_)
  );
  AOI21_X1 _609_ (
    .A(_247_),
    .B1(_147_),
    .B2(_144_),
    .ZN(_270_)
  );
  NAND2_X1 _610_ (
    .A1(_248_),
    .A2(_269_),
    .ZN(_271_)
  );
  OR4_X1 _611_ (
    .A1(state[5]),
    .A2(_161_),
    .A3(_267_),
    .A4(_270_),
    .ZN(_272_)
  );
  AND2_X1 _612_ (
    .A1(_267_),
    .A2(_270_),
    .ZN(_273_)
  );
  OAI211_X1 _613_ (
    .A(_267_),
    .B(_270_),
    .C1(state[5]),
    .C2(_161_),
    .ZN(_274_)
  );
  NAND3_X1 _614_ (
    .A1(_267_),
    .A2(_268_),
    .A3(_271_),
    .ZN(_275_)
  );
  OAI222_X1 _615_ (
    .A1(_017_),
    .A2(_272_),
    .B1(_274_),
    .B2(_016_),
    .C1(_015_),
    .C2(_275_),
    .ZN(data_to_tx[30])
  );
  OAI222_X1 _616_ (
    .A1(_020_),
    .A2(_272_),
    .B1(_274_),
    .B2(_019_),
    .C1(_018_),
    .C2(_275_),
    .ZN(data_to_tx[29])
  );
  OAI222_X1 _617_ (
    .A1(_023_),
    .A2(_272_),
    .B1(_274_),
    .B2(_022_),
    .C1(_021_),
    .C2(_275_),
    .ZN(data_to_tx[28])
  );
  OAI222_X1 _618_ (
    .A1(_024_),
    .A2(_274_),
    .B1(_275_),
    .B2(_025_),
    .C1(_026_),
    .C2(_272_),
    .ZN(data_to_tx[27])
  );
  OAI222_X1 _619_ (
    .A1(_029_),
    .A2(_272_),
    .B1(_274_),
    .B2(_028_),
    .C1(_027_),
    .C2(_275_),
    .ZN(data_to_tx[26])
  );
  OAI222_X1 _620_ (
    .A1(_030_),
    .A2(_274_),
    .B1(_275_),
    .B2(_031_),
    .C1(_032_),
    .C2(_272_),
    .ZN(data_to_tx[25])
  );
  OAI222_X1 _621_ (
    .A1(_033_),
    .A2(_274_),
    .B1(_275_),
    .B2(_034_),
    .C1(_035_),
    .C2(_272_),
    .ZN(data_to_tx[24])
  );
  OAI222_X1 _622_ (
    .A1(_036_),
    .A2(_274_),
    .B1(_275_),
    .B2(_037_),
    .C1(_038_),
    .C2(_272_),
    .ZN(data_to_tx[23])
  );
  OAI222_X1 _623_ (
    .A1(_039_),
    .A2(_274_),
    .B1(_275_),
    .B2(_040_),
    .C1(_041_),
    .C2(_272_),
    .ZN(data_to_tx[22])
  );
  OAI222_X1 _624_ (
    .A1(_042_),
    .A2(_274_),
    .B1(_275_),
    .B2(_043_),
    .C1(_044_),
    .C2(_272_),
    .ZN(data_to_tx[21])
  );
  OAI222_X1 _625_ (
    .A1(_047_),
    .A2(_272_),
    .B1(_274_),
    .B2(_046_),
    .C1(_045_),
    .C2(_275_),
    .ZN(data_to_tx[20])
  );
  OAI222_X1 _626_ (
    .A1(_050_),
    .A2(_272_),
    .B1(_274_),
    .B2(_049_),
    .C1(_048_),
    .C2(_275_),
    .ZN(data_to_tx[19])
  );
  OAI222_X1 _627_ (
    .A1(_051_),
    .A2(_274_),
    .B1(_275_),
    .B2(_052_),
    .C1(_053_),
    .C2(_272_),
    .ZN(data_to_tx[18])
  );
  OAI222_X1 _628_ (
    .A1(_054_),
    .A2(_274_),
    .B1(_275_),
    .B2(_055_),
    .C1(_056_),
    .C2(_272_),
    .ZN(data_to_tx[17])
  );
  OAI222_X1 _629_ (
    .A1(_057_),
    .A2(_274_),
    .B1(_275_),
    .B2(_058_),
    .C1(_059_),
    .C2(_272_),
    .ZN(data_to_tx[16])
  );
  OAI222_X1 _630_ (
    .A1(_060_),
    .A2(_274_),
    .B1(_275_),
    .B2(_061_),
    .C1(_062_),
    .C2(_272_),
    .ZN(data_to_tx[15])
  );
  OAI222_X1 _631_ (
    .A1(_063_),
    .A2(_274_),
    .B1(_275_),
    .B2(_064_),
    .C1(_065_),
    .C2(_272_),
    .ZN(data_to_tx[14])
  );
  OAI222_X1 _632_ (
    .A1(_068_),
    .A2(_272_),
    .B1(_274_),
    .B2(_067_),
    .C1(_066_),
    .C2(_275_),
    .ZN(data_to_tx[13])
  );
  OAI222_X1 _633_ (
    .A1(_069_),
    .A2(_274_),
    .B1(_275_),
    .B2(_070_),
    .C1(_071_),
    .C2(_272_),
    .ZN(data_to_tx[12])
  );
  OAI222_X1 _634_ (
    .A1(_072_),
    .A2(_274_),
    .B1(_275_),
    .B2(_073_),
    .C1(_074_),
    .C2(_272_),
    .ZN(data_to_tx[11])
  );
  OAI222_X1 _635_ (
    .A1(_077_),
    .A2(_272_),
    .B1(_274_),
    .B2(_076_),
    .C1(_075_),
    .C2(_275_),
    .ZN(data_to_tx[10])
  );
  OAI222_X1 _636_ (
    .A1(_078_),
    .A2(_274_),
    .B1(_275_),
    .B2(_079_),
    .C1(_080_),
    .C2(_272_),
    .ZN(data_to_tx[9])
  );
  OAI222_X1 _637_ (
    .A1(_081_),
    .A2(_274_),
    .B1(_275_),
    .B2(_082_),
    .C1(_083_),
    .C2(_272_),
    .ZN(data_to_tx[8])
  );
  OAI222_X1 _638_ (
    .A1(_086_),
    .A2(_272_),
    .B1(_274_),
    .B2(_085_),
    .C1(_084_),
    .C2(_275_),
    .ZN(data_to_tx[7])
  );
  OAI222_X1 _639_ (
    .A1(_087_),
    .A2(_274_),
    .B1(_275_),
    .B2(_088_),
    .C1(_089_),
    .C2(_272_),
    .ZN(data_to_tx[6])
  );
  OAI222_X1 _640_ (
    .A1(_092_),
    .A2(_272_),
    .B1(_274_),
    .B2(_091_),
    .C1(_090_),
    .C2(_275_),
    .ZN(data_to_tx[5])
  );
  OAI222_X1 _641_ (
    .A1(_095_),
    .A2(_272_),
    .B1(_274_),
    .B2(_094_),
    .C1(_093_),
    .C2(_275_),
    .ZN(data_to_tx[4])
  );
  OAI222_X1 _642_ (
    .A1(_098_),
    .A2(_272_),
    .B1(_274_),
    .B2(_097_),
    .C1(_096_),
    .C2(_275_),
    .ZN(data_to_tx[3])
  );
  OAI222_X1 _643_ (
    .A1(_099_),
    .A2(_274_),
    .B1(_275_),
    .B2(_100_),
    .C1(_101_),
    .C2(_272_),
    .ZN(data_to_tx[2])
  );
  OAI222_X1 _644_ (
    .A1(_102_),
    .A2(_274_),
    .B1(_275_),
    .B2(_103_),
    .C1(_104_),
    .C2(_272_),
    .ZN(data_to_tx[1])
  );
  OAI222_X1 _645_ (
    .A1(_105_),
    .A2(_274_),
    .B1(_275_),
    .B2(_106_),
    .C1(_107_),
    .C2(_272_),
    .ZN(data_to_tx[0])
  );
  OAI222_X1 _646_ (
    .A1(_110_),
    .A2(_272_),
    .B1(_274_),
    .B2(_109_),
    .C1(_108_),
    .C2(_275_),
    .ZN(data_to_tx[31])
  );
  AOI21_X1 _647_ (
    .A(_124_),
    .B1(_134_),
    .B2(_160_),
    .ZN(_276_)
  );
  OAI211_X1 _648_ (
    .A(_148_),
    .B(_247_),
    .C1(_276_),
    .C2(_126_),
    .ZN(_277_)
  );
  NAND2_X1 _649_ (
    .A1(_268_),
    .A2(_277_),
    .ZN(_278_)
  );
  OAI22_X1 _650_ (
    .A1(_111_),
    .A2(_274_),
    .B1(_278_),
    .B2(_273_),
    .ZN(data_to_tx_valid)
  );
  AOI22_X1 _651_ (
    .A1(tx_done),
    .A2(state[5]),
    .B1(state[6]),
    .B2(spi_fall),
    .ZN(_279_)
  );
  OAI21_X1 _652_ (
    .A(_279_),
    .B1(_133_),
    .B2(_118_),
    .ZN(eot)
  );
  NAND2_X1 _653_ (
    .A1(tx_done),
    .A2(_134_),
    .ZN(_280_)
  );
  NAND2_X1 _654_ (
    .A1(state[1]),
    .A2(_280_),
    .ZN(_281_)
  );
  NOR2_X1 _655_ (
    .A1(tx_done),
    .A2(_014_),
    .ZN(_282_)
  );
  OAI21_X1 _656_ (
    .A(tx_clk_en),
    .B1(_282_),
    .B2(state[1]),
    .ZN(_283_)
  );
  AOI211_X1 _657_ (
    .A(_125_),
    .B(_147_),
    .C1(state[3]),
    .C2(rx_clk_en),
    .ZN(_284_)
  );
  NAND3_X1 _658_ (
    .A1(_281_),
    .A2(_283_),
    .A3(_284_),
    .ZN(spi_clock_en)
  );
  AOI21_X1 _659_ (
    .A(_132_),
    .B1(_253_),
    .B2(do_rx),
    .ZN(_285_)
  );
  OAI21_X1 _660_ (
    .A(_269_),
    .B1(_264_),
    .B2(_149_),
    .ZN(_286_)
  );
  INV_X1 _661_ (
    .A(_286_),
    .ZN(_287_)
  );
  NOR3_X1 _662_ (
    .A1(state[1]),
    .A2(state[2]),
    .A3(state[5]),
    .ZN(_288_)
  );
  NAND2_X1 _663_ (
    .A1(_010_),
    .A2(state[4]),
    .ZN(_289_)
  );
  OAI21_X1 _664_ (
    .A(state[4]),
    .B1(_123_),
    .B2(_285_),
    .ZN(_290_)
  );
  NAND4_X1 _665_ (
    .A1(_287_),
    .A2(_288_),
    .A3(_289_),
    .A4(_290_),
    .ZN(spi_en_tx)
  );
  NAND3_X1 _666_ (
    .A1(state[0]),
    .A2(_122_),
    .A3(_142_),
    .ZN(_291_)
  );
  OAI222_X1 _667_ (
    .A1(_013_),
    .A2(_118_),
    .B1(_127_),
    .B2(_257_),
    .C1(_265_),
    .C2(_291_),
    .ZN(_292_)
  );
  NAND2_X1 _668_ (
    .A1(_133_),
    .A2(_292_),
    .ZN(_293_)
  );
  INV_X1 _669_ (
    .A(_293_),
    .ZN(counter_rx_valid)
  );
  OAI21_X1 _670_ (
    .A(_293_),
    .B1(rx_done),
    .B2(_113_),
    .ZN(spi_en_rx)
  );
  MUX2_X1 _671_ (
    .A(spi_dummy_wr[13]),
    .B(spi_dummy_wr[15]),
    .S(_117_),
    .Z(_294_)
  );
  NOR2_X1 _672_ (
    .A1(spi_dummy_rd[15]),
    .A2(en_quad),
    .ZN(_295_)
  );
  OAI21_X1 _673_ (
    .A(_165_),
    .B1(_117_),
    .B2(spi_dummy_rd[13]),
    .ZN(_296_)
  );
  AOI22_X1 _674_ (
    .A1(spi_data_len[15]),
    .A2(_163_),
    .B1(_294_),
    .B2(_152_),
    .ZN(_297_)
  );
  OAI21_X1 _675_ (
    .A(_297_),
    .B1(_296_),
    .B2(_295_),
    .ZN(counter_tx[15])
  );
  NAND2_X1 _676_ (
    .A1(state[1]),
    .A2(_134_),
    .ZN(_298_)
  );
  OAI22_X1 _677_ (
    .A1(_009_),
    .A2(state[2]),
    .B1(_124_),
    .B2(_285_),
    .ZN(_299_)
  );
  AOI22_X1 _678_ (
    .A1(_118_),
    .A2(_126_),
    .B1(_298_),
    .B2(_299_),
    .ZN(_300_)
  );
  OR2_X1 _679_ (
    .A1(_286_),
    .A2(_300_),
    .ZN(counter_tx_valid)
  );
  AND2_X1 _680_ (
    .A1(spi_data_len[15]),
    .A2(_292_),
    .ZN(counter_rx[15])
  );
  NAND2_X1 _681_ (
    .A1(_112_),
    .A2(_113_),
    .ZN(spi_status[6])
  );
  AOI211_X1 _682_ (
    .A(_164_),
    .B(spi_status[6]),
    .C1(_280_),
    .C2(state[1]),
    .ZN(_301_)
  );
  NOR2_X1 _683_ (
    .A1(spi_qrd),
    .A2(_132_),
    .ZN(_302_)
  );
  NOR3_X1 _684_ (
    .A1(state[4]),
    .A2(state[0]),
    .A3(spi_status[6]),
    .ZN(_303_)
  );
  AOI22_X1 _685_ (
    .A1(state[0]),
    .A2(_145_),
    .B1(_288_),
    .B2(_303_),
    .ZN(_304_)
  );
  OAI221_X1 _686_ (
    .A(_304_),
    .B1(_302_),
    .B2(_291_),
    .C1(_117_),
    .C2(_301_),
    .ZN(s_spi_mode[1])
  );
  AND2_X1 _687_ (
    .A1(spi_data_len[13]),
    .A2(_292_),
    .ZN(counter_rx[13])
  );
  AND2_X1 _688_ (
    .A1(spi_data_len[12]),
    .A2(_292_),
    .ZN(counter_rx[12])
  );
  AND2_X1 _689_ (
    .A1(spi_data_len[11]),
    .A2(_292_),
    .ZN(counter_rx[11])
  );
  AND2_X1 _690_ (
    .A1(spi_data_len[10]),
    .A2(_292_),
    .ZN(counter_rx[10])
  );
  AND2_X1 _691_ (
    .A1(spi_data_len[9]),
    .A2(_292_),
    .ZN(counter_rx[9])
  );
  AND2_X1 _692_ (
    .A1(spi_data_len[8]),
    .A2(_292_),
    .ZN(counter_rx[8])
  );
  AND2_X1 _693_ (
    .A1(spi_data_len[7]),
    .A2(_292_),
    .ZN(counter_rx[7])
  );
  AND2_X1 _694_ (
    .A1(spi_data_len[6]),
    .A2(_292_),
    .ZN(counter_rx[6])
  );
  AND2_X1 _695_ (
    .A1(spi_data_len[5]),
    .A2(_292_),
    .ZN(counter_rx[5])
  );
  AND2_X1 _696_ (
    .A1(spi_data_len[4]),
    .A2(_292_),
    .ZN(counter_rx[4])
  );
  AND2_X1 _697_ (
    .A1(spi_data_len[3]),
    .A2(_292_),
    .ZN(counter_rx[3])
  );
  AND2_X1 _698_ (
    .A1(spi_data_len[2]),
    .A2(_292_),
    .ZN(counter_rx[2])
  );
  AND2_X1 _699_ (
    .A1(spi_data_len[1]),
    .A2(_292_),
    .ZN(counter_rx[1])
  );
  AND2_X1 _700_ (
    .A1(spi_data_len[0]),
    .A2(_292_),
    .ZN(counter_rx[0])
  );
  NAND2_X1 _701_ (
    .A1(spi_qwr),
    .A2(_138_),
    .ZN(_305_)
  );
  OAI22_X1 _702_ (
    .A1(_116_),
    .A2(_143_),
    .B1(_206_),
    .B2(_305_),
    .ZN(_306_)
  );
  NAND3_X1 _703_ (
    .A1(tx_done),
    .A2(do_rx),
    .A3(_133_),
    .ZN(_307_)
  );
  NAND2_X1 _704_ (
    .A1(_119_),
    .A2(_133_),
    .ZN(_308_)
  );
  AOI221_X1 _705_ (
    .A(state[5]),
    .B1(_125_),
    .B2(_307_),
    .C1(_123_),
    .C2(state[4]),
    .ZN(_309_)
  );
  AOI21_X1 _706_ (
    .A(_117_),
    .B1(_308_),
    .B2(_309_),
    .ZN(_310_)
  );
  AOI21_X1 _707_ (
    .A(_310_),
    .B1(_306_),
    .B2(state[0]),
    .ZN(_311_)
  );
  INV_X1 _708_ (
    .A(_311_),
    .ZN(s_spi_mode[0])
  );
  NAND2_X1 _709_ (
    .A1(_010_),
    .A2(state[2]),
    .ZN(_312_)
  );
  NAND3_X1 _710_ (
    .A1(_248_),
    .A2(_261_),
    .A3(_312_),
    .ZN(_002_)
  );
  AOI21_X1 _711_ (
    .A(_266_),
    .B1(_255_),
    .B2(_135_),
    .ZN(_313_)
  );
  OAI211_X1 _712_ (
    .A(_260_),
    .B(_313_),
    .C1(_137_),
    .C2(_160_),
    .ZN(_001_)
  );
  OAI21_X1 _713_ (
    .A(_127_),
    .B1(_144_),
    .B2(_148_),
    .ZN(_314_)
  );
  AOI21_X1 _714_ (
    .A(eot),
    .B1(_314_),
    .B2(_132_),
    .ZN(_315_)
  );
  OAI21_X1 _715_ (
    .A(_315_),
    .B1(_146_),
    .B2(_012_),
    .ZN(_000_)
  );
  OAI22_X1 _716_ (
    .A1(_112_),
    .A2(spi_fall),
    .B1(_113_),
    .B2(_114_),
    .ZN(_005_)
  );
  AOI221_X1 _717_ (
    .A(_282_),
    .B1(_160_),
    .B2(_152_),
    .C1(_119_),
    .C2(_133_),
    .ZN(_316_)
  );
  INV_X1 _718_ (
    .A(_316_),
    .ZN(_004_)
  );
  NAND2_X1 _719_ (
    .A1(spi_csreg[3]),
    .A2(_304_),
    .ZN(spi_csn3)
  );
  NAND2_X1 _720_ (
    .A1(spi_csreg[2]),
    .A2(_304_),
    .ZN(spi_csn2)
  );
  NAND2_X1 _721_ (
    .A1(spi_csreg[1]),
    .A2(_304_),
    .ZN(spi_csn1)
  );
  NAND2_X1 _722_ (
    .A1(spi_csreg[0]),
    .A2(_304_),
    .ZN(spi_csn0)
  );
  OAI21_X1 _723_ (
    .A(_289_),
    .B1(_148_),
    .B2(_142_),
    .ZN(_003_)
  );
  NOR2_X1 _724_ (
    .A1(_115_),
    .A2(_274_),
    .ZN(spi_ctrl_data_tx_ready)
  );
  AND2_X1 _725_ (
    .A1(spi_data_len[14]),
    .A2(_292_),
    .ZN(counter_rx[14])
  );
  AOI21_X1 _726_ (
    .A(state[3]),
    .B1(_010_),
    .B2(state[1]),
    .ZN(_317_)
  );
  OAI211_X1 _727_ (
    .A(_308_),
    .B(_317_),
    .C1(_112_),
    .C2(spi_fall),
    .ZN(_318_)
  );
  NOR4_X1 _728_ (
    .A1(_136_),
    .A2(_002_),
    .A3(_003_),
    .A4(_318_),
    .ZN(_319_)
  );
  AND4_X1 _729_ (
    .A1(_293_),
    .A2(_313_),
    .A3(_316_),
    .A4(_319_),
    .ZN(_320_)
  );
  NAND2_X1 _730_ (
    .A1(do_rx),
    .A2(_145_),
    .ZN(_321_)
  );
  OAI21_X1 _731_ (
    .A(_138_),
    .B1(_320_),
    .B2(_321_),
    .ZN(_007_)
  );
  AOI21_X1 _732_ (
    .A(_117_),
    .B1(_320_),
    .B2(_116_),
    .ZN(_008_)
  );
  DFFR_X1 _733_ (
    .CK(clk),
    .D(s_spi_mode[0]),
    .Q(spi_mode[0]),
    .QN(_330_),
    .RN(rstn)
  );
  DFFS_X1 _734_ (
    .CK(clk),
    .D(s_spi_mode[1]),
    .Q(spi_mode[1]),
    .QN(_323_),
    .SN(rstn)
  );
  DFFR_X1 _735_ (
    .CK(clk),
    .D(_008_),
    .Q(en_quad_int),
    .QN(_326_),
    .RN(rstn)
  );
  DFFR_X1 _736_ (
    .CK(clk),
    .D(_007_),
    .Q(do_rx),
    .QN(_006_),
    .RN(rstn)
  );
  DFFS_X1 _737_ (
    .CK(clk),
    .D(_000_),
    .Q(state[0]),
    .QN(_329_),
    .SN(rstn)
  );
  DFFR_X1 _738_ (
    .CK(clk),
    .D(_001_),
    .Q(state[1]),
    .QN(_327_),
    .RN(rstn)
  );
  DFFR_X1 _739_ (
    .CK(clk),
    .D(_002_),
    .Q(state[2]),
    .QN(_325_),
    .RN(rstn)
  );
  DFFR_X1 _740_ (
    .CK(clk),
    .D(spi_en_rx),
    .Q(state[3]),
    .QN(_324_),
    .RN(rstn)
  );
  DFFR_X1 _741_ (
    .CK(clk),
    .D(_003_),
    .Q(state[4]),
    .QN(_322_),
    .RN(rstn)
  );
  DFFR_X1 _742_ (
    .CK(clk),
    .D(_004_),
    .Q(state[5]),
    .QN(_331_),
    .RN(rstn)
  );
  DFFR_X1 _743_ (
    .CK(clk),
    .D(_005_),
    .Q(state[6]),
    .QN(_328_),
    .RN(rstn)
  );
  spi_master_clkgen u_clkgen (
    .clk(clk),
    .clk_div(spi_clk_div),
    .clk_div_valid(spi_clk_div_valid),
    .en(spi_clock_en),
    .rstn(rstn),
    .spi_clk(spi_clk),
    .spi_fall(spi_fall),
    .spi_rise(spi_rise)
  );
  spi_master_rx u_rxreg (
    .clk(clk),
    .clk_en_o(rx_clk_en),
    .counter_in(counter_rx),
    .counter_in_upd(counter_rx_valid),
    .data(spi_ctrl_data_rx),
    .data_ready(spi_ctrl_data_rx_ready),
    .data_valid(spi_ctrl_data_rx_valid),
    .en(spi_en_rx),
    .en_quad_in(en_quad),
    .rstn(rstn),
    .rx_done(rx_done),
    .rx_edge(spi_rise),
    .sdi0(spi_sdi0),
    .sdi1(spi_sdi1),
    .sdi2(spi_sdi2),
    .sdi3(spi_sdi3)
  );
  spi_master_tx u_txreg (
    .clk(clk),
    .clk_en_o(tx_clk_en),
    .counter_in(counter_tx),
    .counter_in_upd(counter_tx_valid),
    .data(data_to_tx),
    .data_ready(data_to_tx_ready),
    .data_valid(data_to_tx_valid),
    .en(spi_en_tx),
    .en_quad_in(en_quad),
    .rstn(rstn),
    .sdo0(spi_sdo0),
    .sdo1(spi_sdo1),
    .sdo2(spi_sdo2),
    .sdo3(spi_sdo3),
    .tx_done(tx_done),
    .tx_edge(spi_fall)
  );
  assign state_next[4:3] = 2'h0;
  assign spi_status[5:0] = { state[5], state[1], 1'h0, state[2], state[4], state[0] };
endmodule

module spi_master_rx(clk, rstn, en, rx_edge, rx_done, sdi0, sdi1, sdi2, sdi3, en_quad_in, counter_in, counter_in_upd, data, data_ready, data_valid, clk_en_o);
  input clk;
  wire clk;
  input rstn;
  wire rstn;
  input en;
  wire en;
  input rx_edge;
  wire rx_edge;
  output rx_done;
  wire rx_done;
  input sdi0;
  wire sdi0;
  input sdi1;
  wire sdi1;
  input sdi2;
  wire sdi2;
  input sdi3;
  wire sdi3;
  input en_quad_in;
  wire en_quad_in;
  input [15:0] counter_in;
  wire [15:0] counter_in;
  input counter_in_upd;
  wire counter_in_upd;
  output [31:0] data;
  wire [31:0] data;
  input data_ready;
  wire data_ready;
  output data_valid;
  wire data_valid;
  output clk_en_o;
  wire clk_en_o;
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
  wire _201_;
  wire _202_;
  wire _203_;
  wire _204_;
  wire _205_;
  wire _206_;
  wire _207_;
  wire _208_;
  wire _209_;
  wire _210_;
  wire _211_;
  wire _212_;
  wire _213_;
  wire _214_;
  wire _215_;
  wire _216_;
  wire _217_;
  wire _218_;
  wire _219_;
  wire _220_;
  wire _221_;
  wire _222_;
  wire _223_;
  wire _224_;
  wire _225_;
  wire _226_;
  wire _227_;
  wire _228_;
  wire _229_;
  wire _230_;
  wire _231_;
  wire _232_;
  wire _233_;
  wire _234_;
  wire _235_;
  wire _236_;
  wire _237_;
  wire _238_;
  wire _239_;
  wire _240_;
  wire _241_;
  wire _242_;
  wire _243_;
  wire _244_;
  wire _245_;
  wire _246_;
  wire _247_;
  wire _248_;
  wire _249_;
  wire _250_;
  wire _251_;
  wire _252_;
  wire _253_;
  wire _254_;
  wire _255_;
  wire _256_;
  wire _257_;
  wire _258_;
  wire _259_;
  wire _260_;
  wire _261_;
  wire _262_;
  wire _263_;
  wire [15:0] counter;
  wire [15:0] counter_trgt;
  wire [31:0] data_int;
  wire [31:0] data_int_next;
  wire done;
  wire [3:0] rx_CS;
  INV_X1 _264_ (
    .A(data_ready),
    .ZN(_036_)
  );
  INV_X1 _265_ (
    .A(counter_trgt[13]),
    .ZN(_037_)
  );
  INV_X1 _266_ (
    .A(counter_trgt[14]),
    .ZN(_038_)
  );
  INV_X1 _267_ (
    .A(counter_trgt[15]),
    .ZN(_039_)
  );
  INV_X1 _268_ (
    .A(counter[0]),
    .ZN(_040_)
  );
  INV_X1 _269_ (
    .A(rx_edge),
    .ZN(_041_)
  );
  INV_X1 _270_ (
    .A(counter[10]),
    .ZN(_042_)
  );
  INV_X1 _271_ (
    .A(counter[13]),
    .ZN(_043_)
  );
  INV_X1 _272_ (
    .A(rx_CS[2]),
    .ZN(_044_)
  );
  INV_X1 _273_ (
    .A(en_quad_in),
    .ZN(_045_)
  );
  INV_X1 _274_ (
    .A(rx_CS[0]),
    .ZN(_046_)
  );
  INV_X1 _275_ (
    .A(counter_in[14]),
    .ZN(_047_)
  );
  INV_X1 _276_ (
    .A(counter_in[15]),
    .ZN(_048_)
  );
  NOR2_X1 _277_ (
    .A1(counter_trgt[0]),
    .A2(counter_trgt[1]),
    .ZN(_049_)
  );
  NOR3_X1 _278_ (
    .A1(counter_trgt[0]),
    .A2(counter_trgt[1]),
    .A3(counter_trgt[2]),
    .ZN(_050_)
  );
  OR4_X1 _279_ (
    .A1(counter_trgt[0]),
    .A2(counter_trgt[1]),
    .A3(counter_trgt[2]),
    .A4(counter_trgt[3]),
    .ZN(_051_)
  );
  NOR2_X1 _280_ (
    .A1(counter_trgt[4]),
    .A2(_051_),
    .ZN(_052_)
  );
  NOR3_X1 _281_ (
    .A1(counter_trgt[4]),
    .A2(counter_trgt[5]),
    .A3(_051_),
    .ZN(_053_)
  );
  OR4_X1 _282_ (
    .A1(counter_trgt[4]),
    .A2(counter_trgt[5]),
    .A3(counter_trgt[6]),
    .A4(_051_),
    .ZN(_054_)
  );
  NOR2_X1 _283_ (
    .A1(counter_trgt[7]),
    .A2(_054_),
    .ZN(_055_)
  );
  NOR3_X1 _284_ (
    .A1(counter_trgt[7]),
    .A2(counter_trgt[8]),
    .A3(_054_),
    .ZN(_056_)
  );
  OR4_X1 _285_ (
    .A1(counter_trgt[7]),
    .A2(counter_trgt[8]),
    .A3(counter_trgt[9]),
    .A4(_054_),
    .ZN(_057_)
  );
  NOR2_X1 _286_ (
    .A1(counter_trgt[10]),
    .A2(_057_),
    .ZN(_058_)
  );
  NOR3_X1 _287_ (
    .A1(counter_trgt[10]),
    .A2(counter_trgt[11]),
    .A3(_057_),
    .ZN(_059_)
  );
  NOR4_X1 _288_ (
    .A1(counter_trgt[10]),
    .A2(counter_trgt[11]),
    .A3(counter_trgt[12]),
    .A4(_057_),
    .ZN(_060_)
  );
  NAND2_X1 _289_ (
    .A1(_037_),
    .A2(_060_),
    .ZN(_061_)
  );
  XNOR2_X1 _290_ (
    .A(counter_trgt[13]),
    .B(_060_),
    .ZN(_062_)
  );
  XNOR2_X1 _291_ (
    .A(counter[13]),
    .B(_062_),
    .ZN(_063_)
  );
  NAND3_X1 _292_ (
    .A1(_037_),
    .A2(_038_),
    .A3(_060_),
    .ZN(_064_)
  );
  XNOR2_X1 _293_ (
    .A(_038_),
    .B(_061_),
    .ZN(_065_)
  );
  XNOR2_X1 _294_ (
    .A(counter[14]),
    .B(_065_),
    .ZN(_066_)
  );
  OR2_X1 _295_ (
    .A1(counter_trgt[15]),
    .A2(_064_),
    .ZN(_067_)
  );
  XOR2_X1 _296_ (
    .A(counter_trgt[1]),
    .B(counter[1]),
    .Z(_068_)
  );
  OAI21_X1 _297_ (
    .A(_068_),
    .B1(_040_),
    .B2(counter_trgt[0]),
    .ZN(_069_)
  );
  AND2_X1 _298_ (
    .A1(counter_trgt[0]),
    .A2(_040_),
    .ZN(_070_)
  );
  OAI211_X1 _299_ (
    .A(rx_edge),
    .B(_069_),
    .C1(_070_),
    .C2(_068_),
    .ZN(_071_)
  );
  XNOR2_X1 _300_ (
    .A(counter_trgt[2]),
    .B(_049_),
    .ZN(_072_)
  );
  XNOR2_X1 _301_ (
    .A(counter[2]),
    .B(_072_),
    .ZN(_073_)
  );
  XNOR2_X1 _302_ (
    .A(counter_trgt[3]),
    .B(_050_),
    .ZN(_074_)
  );
  XNOR2_X1 _303_ (
    .A(counter[3]),
    .B(_074_),
    .ZN(_075_)
  );
  XOR2_X1 _304_ (
    .A(counter_trgt[4]),
    .B(_051_),
    .Z(_076_)
  );
  XNOR2_X1 _305_ (
    .A(counter[4]),
    .B(_076_),
    .ZN(_077_)
  );
  NOR4_X1 _306_ (
    .A1(_071_),
    .A2(_073_),
    .A3(_075_),
    .A4(_077_),
    .ZN(_078_)
  );
  XOR2_X1 _307_ (
    .A(counter_trgt[5]),
    .B(_052_),
    .Z(_079_)
  );
  XNOR2_X1 _308_ (
    .A(counter[5]),
    .B(_079_),
    .ZN(_080_)
  );
  XOR2_X1 _309_ (
    .A(counter_trgt[6]),
    .B(_053_),
    .Z(_081_)
  );
  XNOR2_X1 _310_ (
    .A(counter[6]),
    .B(_081_),
    .ZN(_082_)
  );
  XNOR2_X1 _311_ (
    .A(counter_trgt[7]),
    .B(_054_),
    .ZN(_083_)
  );
  XNOR2_X1 _312_ (
    .A(counter[7]),
    .B(_083_),
    .ZN(_084_)
  );
  NAND4_X1 _313_ (
    .A1(_078_),
    .A2(_080_),
    .A3(_082_),
    .A4(_084_),
    .ZN(_085_)
  );
  XNOR2_X1 _314_ (
    .A(counter_trgt[8]),
    .B(_055_),
    .ZN(_086_)
  );
  XNOR2_X1 _315_ (
    .A(counter[8]),
    .B(_086_),
    .ZN(_087_)
  );
  XNOR2_X1 _316_ (
    .A(counter_trgt[9]),
    .B(_056_),
    .ZN(_088_)
  );
  XNOR2_X1 _317_ (
    .A(counter[9]),
    .B(_088_),
    .ZN(_089_)
  );
  XOR2_X1 _318_ (
    .A(counter_trgt[10]),
    .B(_057_),
    .Z(_090_)
  );
  XNOR2_X1 _319_ (
    .A(counter[10]),
    .B(_090_),
    .ZN(_091_)
  );
  NOR4_X1 _320_ (
    .A1(_085_),
    .A2(_087_),
    .A3(_089_),
    .A4(_091_),
    .ZN(_092_)
  );
  XOR2_X1 _321_ (
    .A(counter_trgt[11]),
    .B(_058_),
    .Z(_093_)
  );
  XNOR2_X1 _322_ (
    .A(counter[11]),
    .B(_093_),
    .ZN(_094_)
  );
  XOR2_X1 _323_ (
    .A(counter_trgt[12]),
    .B(_059_),
    .Z(_095_)
  );
  XNOR2_X1 _324_ (
    .A(counter[12]),
    .B(_095_),
    .ZN(_096_)
  );
  NAND4_X1 _325_ (
    .A1(_067_),
    .A2(_092_),
    .A3(_094_),
    .A4(_096_),
    .ZN(_097_)
  );
  NAND2_X1 _326_ (
    .A1(counter_trgt[15]),
    .A2(_064_),
    .ZN(_098_)
  );
  XNOR2_X1 _327_ (
    .A(counter[15]),
    .B(_098_),
    .ZN(_099_)
  );
  NOR4_X1 _328_ (
    .A1(_063_),
    .A2(_066_),
    .A3(_097_),
    .A4(_099_),
    .ZN(rx_done)
  );
  NAND2_X1 _329_ (
    .A1(rx_CS[2]),
    .A2(rx_done),
    .ZN(_100_)
  );
  NOR2_X1 _330_ (
    .A1(rx_CS[1]),
    .A2(rx_CS[3]),
    .ZN(_101_)
  );
  NAND3_X1 _331_ (
    .A1(counter[1]),
    .A2(counter[0]),
    .A3(counter[2]),
    .ZN(_102_)
  );
  AND2_X1 _332_ (
    .A1(counter[3]),
    .A2(counter[4]),
    .ZN(_103_)
  );
  NOR2_X1 _333_ (
    .A1(en_quad_in),
    .A2(_103_),
    .ZN(_104_)
  );
  NOR2_X1 _334_ (
    .A1(_102_),
    .A2(_104_),
    .ZN(_105_)
  );
  NAND3_X1 _335_ (
    .A1(rx_edge),
    .A2(rx_CS[2]),
    .A3(_105_),
    .ZN(_106_)
  );
  NAND4_X1 _336_ (
    .A1(_067_),
    .A2(_092_),
    .A3(_094_),
    .A4(_096_),
    .ZN(_107_)
  );
  NOR4_X1 _337_ (
    .A1(_063_),
    .A2(_066_),
    .A3(_099_),
    .A4(_107_),
    .ZN(_108_)
  );
  NAND3_X1 _338_ (
    .A1(_100_),
    .A2(_101_),
    .A3(_106_),
    .ZN(data_valid)
  );
  NOR3_X1 _339_ (
    .A1(rx_CS[1]),
    .A2(rx_CS[3]),
    .A3(rx_CS[0]),
    .ZN(_109_)
  );
  OR3_X1 _340_ (
    .A1(rx_CS[1]),
    .A2(rx_CS[3]),
    .A3(rx_CS[0]),
    .ZN(_110_)
  );
  NAND2_X1 _341_ (
    .A1(rx_edge),
    .A2(_109_),
    .ZN(_111_)
  );
  MUX2_X1 _342_ (
    .A(data_int[29]),
    .B(data_int[26]),
    .S(en_quad_in),
    .Z(_112_)
  );
  MUX2_X1 _343_ (
    .A(_112_),
    .B(data_int[30]),
    .S(_111_),
    .Z(data[30])
  );
  MUX2_X1 _344_ (
    .A(data_int[28]),
    .B(data_int[25]),
    .S(en_quad_in),
    .Z(_113_)
  );
  MUX2_X1 _345_ (
    .A(_113_),
    .B(data_int[29]),
    .S(_111_),
    .Z(data[29])
  );
  MUX2_X1 _346_ (
    .A(data_int[27]),
    .B(data_int[24]),
    .S(en_quad_in),
    .Z(_114_)
  );
  MUX2_X1 _347_ (
    .A(_114_),
    .B(data_int[28]),
    .S(_111_),
    .Z(data[28])
  );
  MUX2_X1 _348_ (
    .A(data_int[26]),
    .B(data_int[23]),
    .S(en_quad_in),
    .Z(_115_)
  );
  MUX2_X1 _349_ (
    .A(_115_),
    .B(data_int[27]),
    .S(_111_),
    .Z(data[27])
  );
  MUX2_X1 _350_ (
    .A(data_int[25]),
    .B(data_int[22]),
    .S(en_quad_in),
    .Z(_116_)
  );
  MUX2_X1 _351_ (
    .A(_116_),
    .B(data_int[26]),
    .S(_111_),
    .Z(data[26])
  );
  MUX2_X1 _352_ (
    .A(data_int[24]),
    .B(data_int[21]),
    .S(en_quad_in),
    .Z(_117_)
  );
  MUX2_X1 _353_ (
    .A(_117_),
    .B(data_int[25]),
    .S(_111_),
    .Z(data[25])
  );
  MUX2_X1 _354_ (
    .A(data_int[23]),
    .B(data_int[20]),
    .S(en_quad_in),
    .Z(_118_)
  );
  MUX2_X1 _355_ (
    .A(_118_),
    .B(data_int[24]),
    .S(_111_),
    .Z(data[24])
  );
  MUX2_X1 _356_ (
    .A(data_int[22]),
    .B(data_int[19]),
    .S(en_quad_in),
    .Z(_119_)
  );
  MUX2_X1 _357_ (
    .A(_119_),
    .B(data_int[23]),
    .S(_111_),
    .Z(data[23])
  );
  MUX2_X1 _358_ (
    .A(data_int[21]),
    .B(data_int[18]),
    .S(en_quad_in),
    .Z(_120_)
  );
  MUX2_X1 _359_ (
    .A(_120_),
    .B(data_int[22]),
    .S(_111_),
    .Z(data[22])
  );
  MUX2_X1 _360_ (
    .A(data_int[20]),
    .B(data_int[17]),
    .S(en_quad_in),
    .Z(_121_)
  );
  MUX2_X1 _361_ (
    .A(_121_),
    .B(data_int[21]),
    .S(_111_),
    .Z(data[21])
  );
  MUX2_X1 _362_ (
    .A(data_int[19]),
    .B(data_int[16]),
    .S(en_quad_in),
    .Z(_122_)
  );
  MUX2_X1 _363_ (
    .A(_122_),
    .B(data_int[20]),
    .S(_111_),
    .Z(data[20])
  );
  MUX2_X1 _364_ (
    .A(data_int[18]),
    .B(data_int[15]),
    .S(en_quad_in),
    .Z(_123_)
  );
  MUX2_X1 _365_ (
    .A(_123_),
    .B(data_int[19]),
    .S(_111_),
    .Z(data[19])
  );
  MUX2_X1 _366_ (
    .A(data_int[17]),
    .B(data_int[14]),
    .S(en_quad_in),
    .Z(_124_)
  );
  MUX2_X1 _367_ (
    .A(_124_),
    .B(data_int[18]),
    .S(_111_),
    .Z(data[18])
  );
  MUX2_X1 _368_ (
    .A(data_int[16]),
    .B(data_int[13]),
    .S(en_quad_in),
    .Z(_125_)
  );
  MUX2_X1 _369_ (
    .A(_125_),
    .B(data_int[17]),
    .S(_111_),
    .Z(data[17])
  );
  MUX2_X1 _370_ (
    .A(data_int[15]),
    .B(data_int[12]),
    .S(en_quad_in),
    .Z(_126_)
  );
  MUX2_X1 _371_ (
    .A(_126_),
    .B(data_int[16]),
    .S(_111_),
    .Z(data[16])
  );
  MUX2_X1 _372_ (
    .A(data_int[14]),
    .B(data_int[11]),
    .S(en_quad_in),
    .Z(_127_)
  );
  MUX2_X1 _373_ (
    .A(_127_),
    .B(data_int[15]),
    .S(_111_),
    .Z(data[15])
  );
  MUX2_X1 _374_ (
    .A(data_int[13]),
    .B(data_int[10]),
    .S(en_quad_in),
    .Z(_128_)
  );
  MUX2_X1 _375_ (
    .A(_128_),
    .B(data_int[14]),
    .S(_111_),
    .Z(data[14])
  );
  MUX2_X1 _376_ (
    .A(data_int[12]),
    .B(data_int[9]),
    .S(en_quad_in),
    .Z(_129_)
  );
  MUX2_X1 _377_ (
    .A(_129_),
    .B(data_int[13]),
    .S(_111_),
    .Z(data[13])
  );
  MUX2_X1 _378_ (
    .A(data_int[11]),
    .B(data_int[8]),
    .S(en_quad_in),
    .Z(_130_)
  );
  MUX2_X1 _379_ (
    .A(_130_),
    .B(data_int[12]),
    .S(_111_),
    .Z(data[12])
  );
  MUX2_X1 _380_ (
    .A(data_int[10]),
    .B(data_int[7]),
    .S(en_quad_in),
    .Z(_131_)
  );
  MUX2_X1 _381_ (
    .A(_131_),
    .B(data_int[11]),
    .S(_111_),
    .Z(data[11])
  );
  MUX2_X1 _382_ (
    .A(data_int[9]),
    .B(data_int[6]),
    .S(en_quad_in),
    .Z(_132_)
  );
  MUX2_X1 _383_ (
    .A(_132_),
    .B(data_int[10]),
    .S(_111_),
    .Z(data[10])
  );
  MUX2_X1 _384_ (
    .A(data_int[8]),
    .B(data_int[5]),
    .S(en_quad_in),
    .Z(_133_)
  );
  MUX2_X1 _385_ (
    .A(_133_),
    .B(data_int[9]),
    .S(_111_),
    .Z(data[9])
  );
  MUX2_X1 _386_ (
    .A(data_int[7]),
    .B(data_int[4]),
    .S(en_quad_in),
    .Z(_134_)
  );
  MUX2_X1 _387_ (
    .A(_134_),
    .B(data_int[8]),
    .S(_111_),
    .Z(data[8])
  );
  MUX2_X1 _388_ (
    .A(data_int[6]),
    .B(data_int[3]),
    .S(en_quad_in),
    .Z(_135_)
  );
  MUX2_X1 _389_ (
    .A(_135_),
    .B(data_int[7]),
    .S(_111_),
    .Z(data[7])
  );
  MUX2_X1 _390_ (
    .A(data_int[5]),
    .B(data_int[2]),
    .S(en_quad_in),
    .Z(_136_)
  );
  MUX2_X1 _391_ (
    .A(_136_),
    .B(data_int[6]),
    .S(_111_),
    .Z(data[6])
  );
  MUX2_X1 _392_ (
    .A(data_int[4]),
    .B(data_int[1]),
    .S(en_quad_in),
    .Z(_137_)
  );
  MUX2_X1 _393_ (
    .A(_137_),
    .B(data_int[5]),
    .S(_111_),
    .Z(data[5])
  );
  MUX2_X1 _394_ (
    .A(data_int[3]),
    .B(data_int[0]),
    .S(en_quad_in),
    .Z(_138_)
  );
  MUX2_X1 _395_ (
    .A(_138_),
    .B(data_int[4]),
    .S(_111_),
    .Z(data[4])
  );
  MUX2_X1 _396_ (
    .A(data_int[2]),
    .B(sdi3),
    .S(en_quad_in),
    .Z(_139_)
  );
  MUX2_X1 _397_ (
    .A(_139_),
    .B(data_int[3]),
    .S(_111_),
    .Z(data[3])
  );
  MUX2_X1 _398_ (
    .A(data_int[1]),
    .B(sdi2),
    .S(en_quad_in),
    .Z(_140_)
  );
  MUX2_X1 _399_ (
    .A(_140_),
    .B(data_int[2]),
    .S(_111_),
    .Z(data[2])
  );
  MUX2_X1 _400_ (
    .A(data_int[0]),
    .B(sdi1),
    .S(en_quad_in),
    .Z(_141_)
  );
  MUX2_X1 _401_ (
    .A(_141_),
    .B(data_int[1]),
    .S(_111_),
    .Z(data[1])
  );
  MUX2_X1 _402_ (
    .A(sdi1),
    .B(sdi0),
    .S(en_quad_in),
    .Z(_142_)
  );
  MUX2_X1 _403_ (
    .A(_142_),
    .B(data_int[0]),
    .S(_111_),
    .Z(data[0])
  );
  NAND2_X1 _404_ (
    .A1(_036_),
    .A2(rx_CS[1]),
    .ZN(_143_)
  );
  NAND3_X1 _405_ (
    .A1(_036_),
    .A2(rx_edge),
    .A3(_105_),
    .ZN(_144_)
  );
  OR2_X1 _406_ (
    .A1(rx_done),
    .A2(_144_),
    .ZN(_145_)
  );
  OAI21_X1 _407_ (
    .A(_143_),
    .B1(_145_),
    .B2(_044_),
    .ZN(_001_)
  );
  AOI21_X1 _408_ (
    .A(rx_CS[3]),
    .B1(rx_done),
    .B2(rx_CS[2]),
    .ZN(_146_)
  );
  OAI22_X1 _409_ (
    .A1(_046_),
    .A2(en),
    .B1(_146_),
    .B2(_036_),
    .ZN(_000_)
  );
  AND2_X1 _410_ (
    .A1(_109_),
    .A2(_145_),
    .ZN(clk_en_o)
  );
  AOI21_X1 _411_ (
    .A(_041_),
    .B1(_105_),
    .B2(_036_),
    .ZN(_147_)
  );
  NAND2_X1 _412_ (
    .A1(rx_CS[2]),
    .A2(_147_),
    .ZN(_148_)
  );
  AOI222_X1 _413_ (
    .A1(_041_),
    .A2(rx_CS[2]),
    .B1(rx_CS[0]),
    .B2(en),
    .C1(rx_CS[1]),
    .C2(data_ready),
    .ZN(_149_)
  );
  OAI21_X1 _414_ (
    .A(_149_),
    .B1(_148_),
    .B2(rx_done),
    .ZN(_002_)
  );
  MUX2_X1 _415_ (
    .A(data_int[30]),
    .B(data_int[27]),
    .S(en_quad_in),
    .Z(_150_)
  );
  MUX2_X1 _416_ (
    .A(_150_),
    .B(data_int[31]),
    .S(_111_),
    .Z(data[31])
  );
  NOR2_X1 _417_ (
    .A1(data_ready),
    .A2(_146_),
    .ZN(_003_)
  );
  MUX2_X1 _418_ (
    .A(counter_in[0]),
    .B(counter_in[2]),
    .S(en_quad_in),
    .Z(_151_)
  );
  MUX2_X1 _419_ (
    .A(counter_trgt[0]),
    .B(_151_),
    .S(counter_in_upd),
    .Z(_004_)
  );
  AOI21_X1 _420_ (
    .A(_110_),
    .B1(rx_CS[2]),
    .B2(_041_),
    .ZN(_152_)
  );
  AND2_X1 _421_ (
    .A1(counter[0]),
    .A2(_152_),
    .ZN(_153_)
  );
  AOI211_X1 _422_ (
    .A(_102_),
    .B(_110_),
    .C1(_041_),
    .C2(rx_CS[2]),
    .ZN(_154_)
  );
  AND2_X1 _423_ (
    .A1(_103_),
    .A2(_154_),
    .ZN(_155_)
  );
  AND4_X1 _424_ (
    .A1(counter[5]),
    .A2(counter[6]),
    .A3(_103_),
    .A4(_154_),
    .ZN(_156_)
  );
  AND2_X1 _425_ (
    .A1(counter[7]),
    .A2(_156_),
    .ZN(_157_)
  );
  NAND2_X1 _426_ (
    .A1(counter[8]),
    .A2(_157_),
    .ZN(_158_)
  );
  NAND4_X1 _427_ (
    .A1(counter[7]),
    .A2(counter[8]),
    .A3(counter[9]),
    .A4(_156_),
    .ZN(_159_)
  );
  NOR2_X1 _428_ (
    .A1(_042_),
    .A2(_159_),
    .ZN(_160_)
  );
  NAND3_X1 _429_ (
    .A1(counter[12]),
    .A2(counter[11]),
    .A3(_160_),
    .ZN(_161_)
  );
  INV_X1 _430_ (
    .A(_161_),
    .ZN(_162_)
  );
  NOR2_X1 _431_ (
    .A1(_043_),
    .A2(_161_),
    .ZN(_163_)
  );
  NAND2_X1 _432_ (
    .A1(counter[14]),
    .A2(_163_),
    .ZN(_164_)
  );
  XNOR2_X1 _433_ (
    .A(counter[14]),
    .B(_163_),
    .ZN(_165_)
  );
  AND2_X1 _434_ (
    .A1(_108_),
    .A2(_152_),
    .ZN(_166_)
  );
  NOR2_X1 _435_ (
    .A1(_165_),
    .A2(_166_),
    .ZN(_005_)
  );
  NOR2_X1 _436_ (
    .A1(counter[13]),
    .A2(_162_),
    .ZN(_167_)
  );
  NOR3_X1 _437_ (
    .A1(_163_),
    .A2(_166_),
    .A3(_167_),
    .ZN(_006_)
  );
  AOI21_X1 _438_ (
    .A(counter[12]),
    .B1(counter[11]),
    .B2(_160_),
    .ZN(_168_)
  );
  NOR3_X1 _439_ (
    .A1(_162_),
    .A2(_166_),
    .A3(_168_),
    .ZN(_007_)
  );
  XNOR2_X1 _440_ (
    .A(counter[11]),
    .B(_160_),
    .ZN(_169_)
  );
  NOR2_X1 _441_ (
    .A1(_166_),
    .A2(_169_),
    .ZN(_008_)
  );
  AND2_X1 _442_ (
    .A1(_042_),
    .A2(_159_),
    .ZN(_170_)
  );
  NOR3_X1 _443_ (
    .A1(_160_),
    .A2(_166_),
    .A3(_170_),
    .ZN(_009_)
  );
  XOR2_X1 _444_ (
    .A(counter[9]),
    .B(_158_),
    .Z(_171_)
  );
  NOR2_X1 _445_ (
    .A1(_166_),
    .A2(_171_),
    .ZN(_010_)
  );
  XNOR2_X1 _446_ (
    .A(counter[8]),
    .B(_157_),
    .ZN(_172_)
  );
  NOR2_X1 _447_ (
    .A1(_166_),
    .A2(_172_),
    .ZN(_011_)
  );
  NOR2_X1 _448_ (
    .A1(counter[7]),
    .A2(_156_),
    .ZN(_173_)
  );
  NOR3_X1 _449_ (
    .A1(_157_),
    .A2(_166_),
    .A3(_173_),
    .ZN(_012_)
  );
  AOI21_X1 _450_ (
    .A(counter[6]),
    .B1(_155_),
    .B2(counter[5]),
    .ZN(_174_)
  );
  NOR3_X1 _451_ (
    .A1(_156_),
    .A2(_166_),
    .A3(_174_),
    .ZN(_013_)
  );
  XNOR2_X1 _452_ (
    .A(counter[5]),
    .B(_155_),
    .ZN(_175_)
  );
  NOR2_X1 _453_ (
    .A1(_166_),
    .A2(_175_),
    .ZN(_014_)
  );
  AOI21_X1 _454_ (
    .A(counter[4]),
    .B1(_154_),
    .B2(counter[3]),
    .ZN(_176_)
  );
  NOR3_X1 _455_ (
    .A1(_155_),
    .A2(_166_),
    .A3(_176_),
    .ZN(_015_)
  );
  XNOR2_X1 _456_ (
    .A(counter[3]),
    .B(_154_),
    .ZN(_177_)
  );
  NOR2_X1 _457_ (
    .A1(_166_),
    .A2(_177_),
    .ZN(_016_)
  );
  AOI21_X1 _458_ (
    .A(counter[2]),
    .B1(_153_),
    .B2(counter[1]),
    .ZN(_178_)
  );
  NOR3_X1 _459_ (
    .A1(_154_),
    .A2(_166_),
    .A3(_178_),
    .ZN(_017_)
  );
  XNOR2_X1 _460_ (
    .A(counter[1]),
    .B(_153_),
    .ZN(_179_)
  );
  NOR2_X1 _461_ (
    .A1(_166_),
    .A2(_179_),
    .ZN(_018_)
  );
  NOR2_X1 _462_ (
    .A1(counter[0]),
    .A2(_152_),
    .ZN(_180_)
  );
  NOR3_X1 _463_ (
    .A1(_153_),
    .A2(_166_),
    .A3(_180_),
    .ZN(_019_)
  );
  NAND2_X1 _464_ (
    .A1(_045_),
    .A2(counter_in_upd),
    .ZN(_181_)
  );
  OAI22_X1 _465_ (
    .A1(_038_),
    .A2(counter_in_upd),
    .B1(_181_),
    .B2(_047_),
    .ZN(_020_)
  );
  MUX2_X1 _466_ (
    .A(counter_in[13]),
    .B(counter_in[15]),
    .S(en_quad_in),
    .Z(_182_)
  );
  MUX2_X1 _467_ (
    .A(counter_trgt[13]),
    .B(_182_),
    .S(counter_in_upd),
    .Z(_021_)
  );
  MUX2_X1 _468_ (
    .A(counter_in[12]),
    .B(counter_in[14]),
    .S(en_quad_in),
    .Z(_183_)
  );
  MUX2_X1 _469_ (
    .A(counter_trgt[12]),
    .B(_183_),
    .S(counter_in_upd),
    .Z(_022_)
  );
  OAI22_X1 _470_ (
    .A1(_039_),
    .A2(counter_in_upd),
    .B1(_181_),
    .B2(_048_),
    .ZN(_023_)
  );
  XOR2_X1 _471_ (
    .A(counter[15]),
    .B(_164_),
    .Z(_184_)
  );
  NOR2_X1 _472_ (
    .A1(_166_),
    .A2(_184_),
    .ZN(_024_)
  );
  MUX2_X1 _473_ (
    .A(counter_in[11]),
    .B(counter_in[13]),
    .S(en_quad_in),
    .Z(_185_)
  );
  MUX2_X1 _474_ (
    .A(counter_trgt[11]),
    .B(_185_),
    .S(counter_in_upd),
    .Z(_025_)
  );
  MUX2_X1 _475_ (
    .A(counter_in[10]),
    .B(counter_in[12]),
    .S(en_quad_in),
    .Z(_186_)
  );
  MUX2_X1 _476_ (
    .A(counter_trgt[10]),
    .B(_186_),
    .S(counter_in_upd),
    .Z(_026_)
  );
  MUX2_X1 _477_ (
    .A(counter_in[9]),
    .B(counter_in[11]),
    .S(en_quad_in),
    .Z(_187_)
  );
  MUX2_X1 _478_ (
    .A(counter_trgt[9]),
    .B(_187_),
    .S(counter_in_upd),
    .Z(_027_)
  );
  MUX2_X1 _479_ (
    .A(counter_in[8]),
    .B(counter_in[10]),
    .S(en_quad_in),
    .Z(_188_)
  );
  MUX2_X1 _480_ (
    .A(counter_trgt[8]),
    .B(_188_),
    .S(counter_in_upd),
    .Z(_028_)
  );
  MUX2_X1 _481_ (
    .A(counter_in[7]),
    .B(counter_in[9]),
    .S(en_quad_in),
    .Z(_189_)
  );
  MUX2_X1 _482_ (
    .A(counter_trgt[7]),
    .B(_189_),
    .S(counter_in_upd),
    .Z(_029_)
  );
  MUX2_X1 _483_ (
    .A(counter_in[6]),
    .B(counter_in[8]),
    .S(en_quad_in),
    .Z(_190_)
  );
  MUX2_X1 _484_ (
    .A(counter_trgt[6]),
    .B(_190_),
    .S(counter_in_upd),
    .Z(_030_)
  );
  MUX2_X1 _485_ (
    .A(counter_in[5]),
    .B(counter_in[7]),
    .S(en_quad_in),
    .Z(_191_)
  );
  MUX2_X1 _486_ (
    .A(counter_trgt[5]),
    .B(_191_),
    .S(counter_in_upd),
    .Z(_031_)
  );
  MUX2_X1 _487_ (
    .A(counter_in[4]),
    .B(counter_in[6]),
    .S(en_quad_in),
    .Z(_192_)
  );
  MUX2_X1 _488_ (
    .A(counter_trgt[4]),
    .B(_192_),
    .S(counter_in_upd),
    .Z(_032_)
  );
  MUX2_X1 _489_ (
    .A(counter_in[3]),
    .B(counter_in[5]),
    .S(en_quad_in),
    .Z(_193_)
  );
  MUX2_X1 _490_ (
    .A(counter_trgt[3]),
    .B(_193_),
    .S(counter_in_upd),
    .Z(_033_)
  );
  MUX2_X1 _491_ (
    .A(counter_in[2]),
    .B(counter_in[4]),
    .S(en_quad_in),
    .Z(_194_)
  );
  MUX2_X1 _492_ (
    .A(counter_trgt[2]),
    .B(_194_),
    .S(counter_in_upd),
    .Z(_034_)
  );
  MUX2_X1 _493_ (
    .A(counter_in[1]),
    .B(counter_in[3]),
    .S(en_quad_in),
    .Z(_195_)
  );
  MUX2_X1 _494_ (
    .A(counter_trgt[1]),
    .B(_195_),
    .S(counter_in_upd),
    .Z(_035_)
  );
  DFFR_X1 _495_ (
    .CK(clk),
    .D(_004_),
    .Q(counter_trgt[0]),
    .QN(_228_),
    .RN(rstn)
  );
  DFFR_X1 _496_ (
    .CK(clk),
    .D(_035_),
    .Q(counter_trgt[1]),
    .QN(_196_),
    .RN(rstn)
  );
  DFFR_X1 _497_ (
    .CK(clk),
    .D(_034_),
    .Q(counter_trgt[2]),
    .QN(_197_),
    .RN(rstn)
  );
  DFFS_X1 _498_ (
    .CK(clk),
    .D(_033_),
    .Q(counter_trgt[3]),
    .QN(_198_),
    .SN(rstn)
  );
  DFFR_X1 _499_ (
    .CK(clk),
    .D(_032_),
    .Q(counter_trgt[4]),
    .QN(_199_),
    .RN(rstn)
  );
  DFFR_X1 _500_ (
    .CK(clk),
    .D(_031_),
    .Q(counter_trgt[5]),
    .QN(_200_),
    .RN(rstn)
  );
  DFFR_X1 _501_ (
    .CK(clk),
    .D(_030_),
    .Q(counter_trgt[6]),
    .QN(_201_),
    .RN(rstn)
  );
  DFFR_X1 _502_ (
    .CK(clk),
    .D(_029_),
    .Q(counter_trgt[7]),
    .QN(_202_),
    .RN(rstn)
  );
  DFFR_X1 _503_ (
    .CK(clk),
    .D(_028_),
    .Q(counter_trgt[8]),
    .QN(_203_),
    .RN(rstn)
  );
  DFFR_X1 _504_ (
    .CK(clk),
    .D(_027_),
    .Q(counter_trgt[9]),
    .QN(_204_),
    .RN(rstn)
  );
  DFFR_X1 _505_ (
    .CK(clk),
    .D(_026_),
    .Q(counter_trgt[10]),
    .QN(_205_),
    .RN(rstn)
  );
  DFFR_X1 _506_ (
    .CK(clk),
    .D(_025_),
    .Q(counter_trgt[11]),
    .QN(_206_),
    .RN(rstn)
  );
  DFFR_X1 _507_ (
    .CK(clk),
    .D(_022_),
    .Q(counter_trgt[12]),
    .QN(_209_),
    .RN(rstn)
  );
  DFFR_X1 _508_ (
    .CK(clk),
    .D(_021_),
    .Q(counter_trgt[13]),
    .QN(_210_),
    .RN(rstn)
  );
  DFFR_X1 _509_ (
    .CK(clk),
    .D(_020_),
    .Q(counter_trgt[14]),
    .QN(_211_),
    .RN(rstn)
  );
  DFFR_X1 _510_ (
    .CK(clk),
    .D(_023_),
    .Q(counter_trgt[15]),
    .QN(_208_),
    .RN(rstn)
  );
  DFFR_X1 _511_ (
    .CK(clk),
    .D(_019_),
    .Q(counter[0]),
    .QN(_262_),
    .RN(rstn)
  );
  DFFR_X1 _512_ (
    .CK(clk),
    .D(_018_),
    .Q(counter[1]),
    .QN(_213_),
    .RN(rstn)
  );
  DFFR_X1 _513_ (
    .CK(clk),
    .D(_017_),
    .Q(counter[2]),
    .QN(_214_),
    .RN(rstn)
  );
  DFFR_X1 _514_ (
    .CK(clk),
    .D(_016_),
    .Q(counter[3]),
    .QN(_215_),
    .RN(rstn)
  );
  DFFR_X1 _515_ (
    .CK(clk),
    .D(_015_),
    .Q(counter[4]),
    .QN(_216_),
    .RN(rstn)
  );
  DFFR_X1 _516_ (
    .CK(clk),
    .D(_014_),
    .Q(counter[5]),
    .QN(_217_),
    .RN(rstn)
  );
  DFFR_X1 _517_ (
    .CK(clk),
    .D(_013_),
    .Q(counter[6]),
    .QN(_218_),
    .RN(rstn)
  );
  DFFR_X1 _518_ (
    .CK(clk),
    .D(_012_),
    .Q(counter[7]),
    .QN(_219_),
    .RN(rstn)
  );
  DFFR_X1 _519_ (
    .CK(clk),
    .D(_011_),
    .Q(counter[8]),
    .QN(_220_),
    .RN(rstn)
  );
  DFFR_X1 _520_ (
    .CK(clk),
    .D(_010_),
    .Q(counter[9]),
    .QN(_221_),
    .RN(rstn)
  );
  DFFR_X1 _521_ (
    .CK(clk),
    .D(_009_),
    .Q(counter[10]),
    .QN(_261_),
    .RN(rstn)
  );
  DFFR_X1 _522_ (
    .CK(clk),
    .D(_008_),
    .Q(counter[11]),
    .QN(_223_),
    .RN(rstn)
  );
  DFFR_X1 _523_ (
    .CK(clk),
    .D(_007_),
    .Q(counter[12]),
    .QN(_224_),
    .RN(rstn)
  );
  DFFR_X1 _524_ (
    .CK(clk),
    .D(_006_),
    .Q(counter[13]),
    .QN(_225_),
    .RN(rstn)
  );
  DFFR_X1 _525_ (
    .CK(clk),
    .D(_005_),
    .Q(counter[14]),
    .QN(_260_),
    .RN(rstn)
  );
  DFFR_X1 _526_ (
    .CK(clk),
    .D(_024_),
    .Q(counter[15]),
    .QN(_207_),
    .RN(rstn)
  );
  DFFS_X1 _527_ (
    .CK(clk),
    .D(_000_),
    .Q(rx_CS[0]),
    .QN(_263_),
    .SN(rstn)
  );
  DFFR_X1 _528_ (
    .CK(clk),
    .D(_001_),
    .Q(rx_CS[1]),
    .QN(_227_),
    .RN(rstn)
  );
  DFFR_X1 _529_ (
    .CK(clk),
    .D(_002_),
    .Q(rx_CS[2]),
    .QN(_259_),
    .RN(rstn)
  );
  DFFR_X1 _530_ (
    .CK(clk),
    .D(_003_),
    .Q(rx_CS[3]),
    .QN(_226_),
    .RN(rstn)
  );
  DFFR_X1 _531_ (
    .CK(clk),
    .D(data[0]),
    .Q(data_int[0]),
    .QN(_238_),
    .RN(rstn)
  );
  DFFR_X1 _532_ (
    .CK(clk),
    .D(data[1]),
    .Q(data_int[1]),
    .QN(_237_),
    .RN(rstn)
  );
  DFFR_X1 _533_ (
    .CK(clk),
    .D(data[2]),
    .Q(data_int[2]),
    .QN(_236_),
    .RN(rstn)
  );
  DFFR_X1 _534_ (
    .CK(clk),
    .D(data[3]),
    .Q(data_int[3]),
    .QN(_235_),
    .RN(rstn)
  );
  DFFR_X1 _535_ (
    .CK(clk),
    .D(data[4]),
    .Q(data_int[4]),
    .QN(_234_),
    .RN(rstn)
  );
  DFFR_X1 _536_ (
    .CK(clk),
    .D(data[5]),
    .Q(data_int[5]),
    .QN(_233_),
    .RN(rstn)
  );
  DFFR_X1 _537_ (
    .CK(clk),
    .D(data[6]),
    .Q(data_int[6]),
    .QN(_232_),
    .RN(rstn)
  );
  DFFR_X1 _538_ (
    .CK(clk),
    .D(data[7]),
    .Q(data_int[7]),
    .QN(_231_),
    .RN(rstn)
  );
  DFFR_X1 _539_ (
    .CK(clk),
    .D(data[8]),
    .Q(data_int[8]),
    .QN(_230_),
    .RN(rstn)
  );
  DFFR_X1 _540_ (
    .CK(clk),
    .D(data[9]),
    .Q(data_int[9]),
    .QN(_229_),
    .RN(rstn)
  );
  DFFR_X1 _541_ (
    .CK(clk),
    .D(data[10]),
    .Q(data_int[10]),
    .QN(_212_),
    .RN(rstn)
  );
  DFFR_X1 _542_ (
    .CK(clk),
    .D(data[11]),
    .Q(data_int[11]),
    .QN(_258_),
    .RN(rstn)
  );
  DFFR_X1 _543_ (
    .CK(clk),
    .D(data[12]),
    .Q(data_int[12]),
    .QN(_257_),
    .RN(rstn)
  );
  DFFR_X1 _544_ (
    .CK(clk),
    .D(data[13]),
    .Q(data_int[13]),
    .QN(_256_),
    .RN(rstn)
  );
  DFFR_X1 _545_ (
    .CK(clk),
    .D(data[14]),
    .Q(data_int[14]),
    .QN(_255_),
    .RN(rstn)
  );
  DFFR_X1 _546_ (
    .CK(clk),
    .D(data[15]),
    .Q(data_int[15]),
    .QN(_254_),
    .RN(rstn)
  );
  DFFR_X1 _547_ (
    .CK(clk),
    .D(data[16]),
    .Q(data_int[16]),
    .QN(_253_),
    .RN(rstn)
  );
  DFFR_X1 _548_ (
    .CK(clk),
    .D(data[17]),
    .Q(data_int[17]),
    .QN(_252_),
    .RN(rstn)
  );
  DFFR_X1 _549_ (
    .CK(clk),
    .D(data[18]),
    .Q(data_int[18]),
    .QN(_251_),
    .RN(rstn)
  );
  DFFR_X1 _550_ (
    .CK(clk),
    .D(data[19]),
    .Q(data_int[19]),
    .QN(_250_),
    .RN(rstn)
  );
  DFFR_X1 _551_ (
    .CK(clk),
    .D(data[20]),
    .Q(data_int[20]),
    .QN(_249_),
    .RN(rstn)
  );
  DFFR_X1 _552_ (
    .CK(clk),
    .D(data[21]),
    .Q(data_int[21]),
    .QN(_248_),
    .RN(rstn)
  );
  DFFR_X1 _553_ (
    .CK(clk),
    .D(data[22]),
    .Q(data_int[22]),
    .QN(_247_),
    .RN(rstn)
  );
  DFFR_X1 _554_ (
    .CK(clk),
    .D(data[23]),
    .Q(data_int[23]),
    .QN(_246_),
    .RN(rstn)
  );
  DFFR_X1 _555_ (
    .CK(clk),
    .D(data[24]),
    .Q(data_int[24]),
    .QN(_245_),
    .RN(rstn)
  );
  DFFR_X1 _556_ (
    .CK(clk),
    .D(data[25]),
    .Q(data_int[25]),
    .QN(_244_),
    .RN(rstn)
  );
  DFFR_X1 _557_ (
    .CK(clk),
    .D(data[26]),
    .Q(data_int[26]),
    .QN(_243_),
    .RN(rstn)
  );
  DFFR_X1 _558_ (
    .CK(clk),
    .D(data[27]),
    .Q(data_int[27]),
    .QN(_242_),
    .RN(rstn)
  );
  DFFR_X1 _559_ (
    .CK(clk),
    .D(data[28]),
    .Q(data_int[28]),
    .QN(_241_),
    .RN(rstn)
  );
  DFFR_X1 _560_ (
    .CK(clk),
    .D(data[29]),
    .Q(data_int[29]),
    .QN(_240_),
    .RN(rstn)
  );
  DFFR_X1 _561_ (
    .CK(clk),
    .D(data[30]),
    .Q(data_int[30]),
    .QN(_239_),
    .RN(rstn)
  );
  DFFR_X1 _562_ (
    .CK(clk),
    .D(data[31]),
    .Q(data_int[31]),
    .QN(_222_),
    .RN(rstn)
  );
  assign done = rx_done;
  assign data_int_next = data;
endmodule

module spi_master_tx(clk, rstn, en, tx_edge, tx_done, sdo0, sdo1, sdo2, sdo3, en_quad_in, counter_in, counter_in_upd, data, data_valid, data_ready, clk_en_o);
  input clk;
  wire clk;
  input rstn;
  wire rstn;
  input en;
  wire en;
  input tx_edge;
  wire tx_edge;
  output tx_done;
  wire tx_done;
  output sdo0;
  wire sdo0;
  output sdo1;
  wire sdo1;
  output sdo2;
  wire sdo2;
  output sdo3;
  wire sdo3;
  input en_quad_in;
  wire en_quad_in;
  input [15:0] counter_in;
  wire [15:0] counter_in;
  input counter_in_upd;
  wire counter_in_upd;
  input [31:0] data;
  wire [31:0] data;
  input data_valid;
  wire data_valid;
  output data_ready;
  wire data_ready;
  output clk_en_o;
  wire clk_en_o;
  wire _0000_;
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
  wire [15:0] counter;
  wire [15:0] counter_trgt;
  wire [31:0] data_int;
  wire done;
  wire [0:0] tx_CS;
  wire [0:0] tx_NS;
  INV_X1 _0513_ (
    .A(tx_CS),
    .ZN(_0064_)
  );
  INV_X1 _0514_ (
    .A(counter[0]),
    .ZN(_0065_)
  );
  INV_X1 _0515_ (
    .A(en_quad_in),
    .ZN(_0066_)
  );
  INV_X1 _0516_ (
    .A(data_valid),
    .ZN(_0067_)
  );
  INV_X1 _0517_ (
    .A(counter_trgt[13]),
    .ZN(_0068_)
  );
  INV_X1 _0518_ (
    .A(counter_trgt[14]),
    .ZN(_0069_)
  );
  INV_X1 _0519_ (
    .A(counter_trgt[15]),
    .ZN(_0070_)
  );
  INV_X1 _0520_ (
    .A(counter[8]),
    .ZN(_0071_)
  );
  INV_X1 _0521_ (
    .A(tx_edge),
    .ZN(_0072_)
  );
  INV_X1 _0522_ (
    .A(counter[5]),
    .ZN(_0073_)
  );
  INV_X1 _0523_ (
    .A(counter[11]),
    .ZN(_0074_)
  );
  INV_X1 _0524_ (
    .A(counter[15]),
    .ZN(_0075_)
  );
  INV_X1 _0525_ (
    .A(data_int[2]),
    .ZN(_0076_)
  );
  INV_X1 _0526_ (
    .A(data_int[1]),
    .ZN(_0077_)
  );
  INV_X1 _0527_ (
    .A(data_int[0]),
    .ZN(_0078_)
  );
  INV_X1 _0528_ (
    .A(data[3]),
    .ZN(_0079_)
  );
  INV_X1 _0529_ (
    .A(data[2]),
    .ZN(_0080_)
  );
  INV_X1 _0530_ (
    .A(data[1]),
    .ZN(_0081_)
  );
  INV_X1 _0531_ (
    .A(counter_in[14]),
    .ZN(_0082_)
  );
  INV_X1 _0532_ (
    .A(counter_in[15]),
    .ZN(_0083_)
  );
  NOR2_X1 _0533_ (
    .A1(counter_trgt[0]),
    .A2(counter_trgt[1]),
    .ZN(_0084_)
  );
  NOR3_X1 _0534_ (
    .A1(counter_trgt[0]),
    .A2(counter_trgt[1]),
    .A3(counter_trgt[2]),
    .ZN(_0085_)
  );
  OR4_X1 _0535_ (
    .A1(counter_trgt[0]),
    .A2(counter_trgt[1]),
    .A3(counter_trgt[2]),
    .A4(counter_trgt[3]),
    .ZN(_0086_)
  );
  NOR2_X1 _0536_ (
    .A1(counter_trgt[4]),
    .A2(_0086_),
    .ZN(_0087_)
  );
  NOR3_X1 _0537_ (
    .A1(counter_trgt[4]),
    .A2(counter_trgt[5]),
    .A3(_0086_),
    .ZN(_0088_)
  );
  OR4_X1 _0538_ (
    .A1(counter_trgt[4]),
    .A2(counter_trgt[5]),
    .A3(counter_trgt[6]),
    .A4(_0086_),
    .ZN(_0089_)
  );
  NOR2_X1 _0539_ (
    .A1(counter_trgt[7]),
    .A2(_0089_),
    .ZN(_0090_)
  );
  NOR3_X1 _0540_ (
    .A1(counter_trgt[7]),
    .A2(counter_trgt[8]),
    .A3(_0089_),
    .ZN(_0091_)
  );
  OR4_X1 _0541_ (
    .A1(counter_trgt[7]),
    .A2(counter_trgt[8]),
    .A3(counter_trgt[9]),
    .A4(_0089_),
    .ZN(_0092_)
  );
  NOR2_X1 _0542_ (
    .A1(counter_trgt[10]),
    .A2(_0092_),
    .ZN(_0093_)
  );
  NOR3_X1 _0543_ (
    .A1(counter_trgt[10]),
    .A2(counter_trgt[11]),
    .A3(_0092_),
    .ZN(_0094_)
  );
  NOR4_X1 _0544_ (
    .A1(counter_trgt[10]),
    .A2(counter_trgt[11]),
    .A3(counter_trgt[12]),
    .A4(_0092_),
    .ZN(_0095_)
  );
  XNOR2_X1 _0545_ (
    .A(_0068_),
    .B(_0095_),
    .ZN(_0096_)
  );
  XNOR2_X1 _0546_ (
    .A(counter[13]),
    .B(_0096_),
    .ZN(_0097_)
  );
  AND3_X1 _0547_ (
    .A1(_0068_),
    .A2(_0069_),
    .A3(_0095_),
    .ZN(_0098_)
  );
  AOI21_X1 _0548_ (
    .A(_0069_),
    .B1(_0095_),
    .B2(_0068_),
    .ZN(_0099_)
  );
  NOR2_X1 _0549_ (
    .A1(_0098_),
    .A2(_0099_),
    .ZN(_0100_)
  );
  XOR2_X1 _0550_ (
    .A(counter[14]),
    .B(_0100_),
    .Z(_0101_)
  );
  XNOR2_X1 _0551_ (
    .A(counter[14]),
    .B(_0100_),
    .ZN(_0102_)
  );
  NAND2_X1 _0552_ (
    .A1(_0070_),
    .A2(_0098_),
    .ZN(_0103_)
  );
  XOR2_X1 _0553_ (
    .A(counter[1]),
    .B(counter_trgt[1]),
    .Z(_0104_)
  );
  OAI21_X1 _0554_ (
    .A(_0104_),
    .B1(counter_trgt[0]),
    .B2(_0065_),
    .ZN(_0105_)
  );
  AND2_X1 _0555_ (
    .A1(_0065_),
    .A2(counter_trgt[0]),
    .ZN(_0106_)
  );
  OAI211_X1 _0556_ (
    .A(tx_edge),
    .B(_0105_),
    .C1(_0106_),
    .C2(_0104_),
    .ZN(_0107_)
  );
  XNOR2_X1 _0557_ (
    .A(counter_trgt[2]),
    .B(_0084_),
    .ZN(_0108_)
  );
  XNOR2_X1 _0558_ (
    .A(counter[2]),
    .B(_0108_),
    .ZN(_0109_)
  );
  XNOR2_X1 _0559_ (
    .A(counter_trgt[3]),
    .B(_0085_),
    .ZN(_0110_)
  );
  XNOR2_X1 _0560_ (
    .A(counter[3]),
    .B(_0110_),
    .ZN(_0111_)
  );
  XOR2_X1 _0561_ (
    .A(counter_trgt[4]),
    .B(_0086_),
    .Z(_0112_)
  );
  XNOR2_X1 _0562_ (
    .A(counter[4]),
    .B(_0112_),
    .ZN(_0113_)
  );
  NOR4_X1 _0563_ (
    .A1(_0107_),
    .A2(_0109_),
    .A3(_0111_),
    .A4(_0113_),
    .ZN(_0114_)
  );
  XNOR2_X1 _0564_ (
    .A(counter_trgt[5]),
    .B(_0087_),
    .ZN(_0115_)
  );
  XNOR2_X1 _0565_ (
    .A(_0073_),
    .B(_0115_),
    .ZN(_0116_)
  );
  XOR2_X1 _0566_ (
    .A(counter_trgt[6]),
    .B(_0088_),
    .Z(_0117_)
  );
  XNOR2_X1 _0567_ (
    .A(counter[6]),
    .B(_0117_),
    .ZN(_0118_)
  );
  XNOR2_X1 _0568_ (
    .A(counter_trgt[7]),
    .B(_0089_),
    .ZN(_0119_)
  );
  XNOR2_X1 _0569_ (
    .A(counter[7]),
    .B(_0119_),
    .ZN(_0120_)
  );
  NAND4_X1 _0570_ (
    .A1(_0114_),
    .A2(_0116_),
    .A3(_0118_),
    .A4(_0120_),
    .ZN(_0121_)
  );
  XNOR2_X1 _0571_ (
    .A(counter_trgt[8]),
    .B(_0090_),
    .ZN(_0122_)
  );
  XNOR2_X1 _0572_ (
    .A(counter[8]),
    .B(_0122_),
    .ZN(_0123_)
  );
  XNOR2_X1 _0573_ (
    .A(counter_trgt[9]),
    .B(_0091_),
    .ZN(_0124_)
  );
  XNOR2_X1 _0574_ (
    .A(counter[9]),
    .B(_0124_),
    .ZN(_0125_)
  );
  XOR2_X1 _0575_ (
    .A(counter_trgt[10]),
    .B(_0092_),
    .Z(_0126_)
  );
  XNOR2_X1 _0576_ (
    .A(counter[10]),
    .B(_0126_),
    .ZN(_0127_)
  );
  NOR4_X1 _0577_ (
    .A1(_0121_),
    .A2(_0123_),
    .A3(_0125_),
    .A4(_0127_),
    .ZN(_0128_)
  );
  XNOR2_X1 _0578_ (
    .A(counter_trgt[11]),
    .B(_0093_),
    .ZN(_0129_)
  );
  XNOR2_X1 _0579_ (
    .A(_0074_),
    .B(_0129_),
    .ZN(_0130_)
  );
  XOR2_X1 _0580_ (
    .A(counter_trgt[12]),
    .B(_0094_),
    .Z(_0131_)
  );
  XNOR2_X1 _0581_ (
    .A(counter[12]),
    .B(_0131_),
    .ZN(_0132_)
  );
  AND4_X1 _0582_ (
    .A1(_0103_),
    .A2(_0128_),
    .A3(_0130_),
    .A4(_0132_),
    .ZN(_0133_)
  );
  NAND4_X1 _0583_ (
    .A1(_0103_),
    .A2(_0128_),
    .A3(_0130_),
    .A4(_0132_),
    .ZN(_0134_)
  );
  OAI21_X1 _0584_ (
    .A(counter[15]),
    .B1(_0098_),
    .B2(_0070_),
    .ZN(_0135_)
  );
  OR3_X1 _0585_ (
    .A1(_0070_),
    .A2(counter[15]),
    .A3(_0098_),
    .ZN(_0136_)
  );
  AND2_X1 _0586_ (
    .A1(_0135_),
    .A2(_0136_),
    .ZN(_0137_)
  );
  AND4_X1 _0587_ (
    .A1(_0097_),
    .A2(_0101_),
    .A3(_0133_),
    .A4(_0137_),
    .ZN(tx_done)
  );
  NAND3_X1 _0588_ (
    .A1(counter[1]),
    .A2(counter[0]),
    .A3(counter[2]),
    .ZN(_0138_)
  );
  AOI21_X1 _0589_ (
    .A(en_quad_in),
    .B1(counter[4]),
    .B2(counter[3]),
    .ZN(_0139_)
  );
  OR3_X1 _0590_ (
    .A1(data_valid),
    .A2(_0138_),
    .A3(_0139_),
    .ZN(_0140_)
  );
  AND2_X1 _0591_ (
    .A1(data_valid),
    .A2(en),
    .ZN(_0141_)
  );
  NAND2_X1 _0592_ (
    .A1(data_valid),
    .A2(en),
    .ZN(_0142_)
  );
  AND3_X1 _0593_ (
    .A1(_0097_),
    .A2(_0135_),
    .A3(_0136_),
    .ZN(_0143_)
  );
  NAND3_X1 _0594_ (
    .A1(_0097_),
    .A2(_0135_),
    .A3(_0136_),
    .ZN(_0144_)
  );
  NOR3_X1 _0595_ (
    .A1(_0102_),
    .A2(_0134_),
    .A3(_0144_),
    .ZN(_0145_)
  );
  NAND4_X1 _0596_ (
    .A1(_0101_),
    .A2(_0133_),
    .A3(_0142_),
    .A4(_0143_),
    .ZN(_0146_)
  );
  AOI21_X1 _0597_ (
    .A(_0072_),
    .B1(_0140_),
    .B2(_0146_),
    .ZN(_0147_)
  );
  NOR2_X1 _0598_ (
    .A1(_0064_),
    .A2(_0147_),
    .ZN(clk_en_o)
  );
  NAND2_X1 _0599_ (
    .A1(_0064_),
    .A2(_0141_),
    .ZN(_0148_)
  );
  OAI21_X1 _0600_ (
    .A(_0148_),
    .B1(_0147_),
    .B2(_0064_),
    .ZN(tx_NS)
  );
  NAND2_X1 _0601_ (
    .A1(tx_CS),
    .A2(tx_edge),
    .ZN(_0149_)
  );
  NOR3_X1 _0602_ (
    .A1(_0067_),
    .A2(_0138_),
    .A3(_0139_),
    .ZN(_0150_)
  );
  OAI33_X1 _0603_ (
    .A1(_0067_),
    .A2(_0138_),
    .A3(_0139_),
    .B1(_0144_),
    .B2(_0134_),
    .B3(_0102_),
    .ZN(_0151_)
  );
  NAND2_X1 _0604_ (
    .A1(_0146_),
    .A2(_0151_),
    .ZN(_0152_)
  );
  AND2_X1 _0605_ (
    .A1(_0148_),
    .A2(_0149_),
    .ZN(_0153_)
  );
  NAND2_X1 _0606_ (
    .A1(_0148_),
    .A2(_0149_),
    .ZN(_0154_)
  );
  AOI21_X1 _0607_ (
    .A(_0153_),
    .B1(_0152_),
    .B2(_0148_),
    .ZN(data_ready)
  );
  MUX2_X1 _0608_ (
    .A(data_int[31]),
    .B(data_int[28]),
    .S(en_quad_in),
    .Z(sdo0)
  );
  NAND2_X1 _0609_ (
    .A1(_0066_),
    .A2(counter_in_upd),
    .ZN(_0155_)
  );
  OAI22_X1 _0610_ (
    .A1(_0069_),
    .A2(counter_in_upd),
    .B1(_0155_),
    .B2(_0082_),
    .ZN(_0000_)
  );
  MUX2_X1 _0611_ (
    .A(counter_in[13]),
    .B(counter_in[15]),
    .S(en_quad_in),
    .Z(_0156_)
  );
  MUX2_X1 _0612_ (
    .A(counter_trgt[13]),
    .B(_0156_),
    .S(counter_in_upd),
    .Z(_0001_)
  );
  MUX2_X1 _0613_ (
    .A(counter_in[12]),
    .B(counter_in[14]),
    .S(en_quad_in),
    .Z(_0157_)
  );
  MUX2_X1 _0614_ (
    .A(counter_trgt[12]),
    .B(_0157_),
    .S(counter_in_upd),
    .Z(_0002_)
  );
  MUX2_X1 _0615_ (
    .A(counter_in[11]),
    .B(counter_in[13]),
    .S(en_quad_in),
    .Z(_0158_)
  );
  MUX2_X1 _0616_ (
    .A(counter_trgt[11]),
    .B(_0158_),
    .S(counter_in_upd),
    .Z(_0003_)
  );
  MUX2_X1 _0617_ (
    .A(counter_in[10]),
    .B(counter_in[12]),
    .S(en_quad_in),
    .Z(_0159_)
  );
  MUX2_X1 _0618_ (
    .A(counter_trgt[10]),
    .B(_0159_),
    .S(counter_in_upd),
    .Z(_0004_)
  );
  MUX2_X1 _0619_ (
    .A(counter_in[9]),
    .B(counter_in[11]),
    .S(en_quad_in),
    .Z(_0160_)
  );
  MUX2_X1 _0620_ (
    .A(counter_trgt[9]),
    .B(_0160_),
    .S(counter_in_upd),
    .Z(_0005_)
  );
  MUX2_X1 _0621_ (
    .A(counter_in[8]),
    .B(counter_in[10]),
    .S(en_quad_in),
    .Z(_0161_)
  );
  MUX2_X1 _0622_ (
    .A(counter_trgt[8]),
    .B(_0161_),
    .S(counter_in_upd),
    .Z(_0006_)
  );
  MUX2_X1 _0623_ (
    .A(counter_in[7]),
    .B(counter_in[9]),
    .S(en_quad_in),
    .Z(_0162_)
  );
  MUX2_X1 _0624_ (
    .A(counter_trgt[7]),
    .B(_0162_),
    .S(counter_in_upd),
    .Z(_0007_)
  );
  MUX2_X1 _0625_ (
    .A(counter_in[6]),
    .B(counter_in[8]),
    .S(en_quad_in),
    .Z(_0163_)
  );
  MUX2_X1 _0626_ (
    .A(counter_trgt[6]),
    .B(_0163_),
    .S(counter_in_upd),
    .Z(_0008_)
  );
  MUX2_X1 _0627_ (
    .A(counter_in[5]),
    .B(counter_in[7]),
    .S(en_quad_in),
    .Z(_0164_)
  );
  MUX2_X1 _0628_ (
    .A(counter_trgt[5]),
    .B(_0164_),
    .S(counter_in_upd),
    .Z(_0009_)
  );
  MUX2_X1 _0629_ (
    .A(counter_in[4]),
    .B(counter_in[6]),
    .S(en_quad_in),
    .Z(_0165_)
  );
  MUX2_X1 _0630_ (
    .A(counter_trgt[4]),
    .B(_0165_),
    .S(counter_in_upd),
    .Z(_0010_)
  );
  MUX2_X1 _0631_ (
    .A(counter_in[3]),
    .B(counter_in[5]),
    .S(en_quad_in),
    .Z(_0166_)
  );
  MUX2_X1 _0632_ (
    .A(counter_trgt[3]),
    .B(_0166_),
    .S(counter_in_upd),
    .Z(_0011_)
  );
  MUX2_X1 _0633_ (
    .A(counter_in[2]),
    .B(counter_in[4]),
    .S(en_quad_in),
    .Z(_0167_)
  );
  MUX2_X1 _0634_ (
    .A(counter_trgt[2]),
    .B(_0167_),
    .S(counter_in_upd),
    .Z(_0012_)
  );
  MUX2_X1 _0635_ (
    .A(counter_in[1]),
    .B(counter_in[3]),
    .S(en_quad_in),
    .Z(_0168_)
  );
  MUX2_X1 _0636_ (
    .A(counter_trgt[1]),
    .B(_0168_),
    .S(counter_in_upd),
    .Z(_0013_)
  );
  MUX2_X1 _0637_ (
    .A(counter_in[0]),
    .B(counter_in[2]),
    .S(en_quad_in),
    .Z(_0169_)
  );
  MUX2_X1 _0638_ (
    .A(counter_trgt[0]),
    .B(_0169_),
    .S(counter_in_upd),
    .Z(_0014_)
  );
  NOR2_X1 _0639_ (
    .A1(_0065_),
    .A2(_0149_),
    .ZN(_0170_)
  );
  NOR2_X1 _0640_ (
    .A1(_0138_),
    .A2(_0149_),
    .ZN(_0171_)
  );
  NAND2_X1 _0641_ (
    .A1(counter[3]),
    .A2(_0171_),
    .ZN(_0172_)
  );
  AND4_X1 _0642_ (
    .A1(counter[3]),
    .A2(counter[4]),
    .A3(counter[5]),
    .A4(_0171_),
    .ZN(_0173_)
  );
  NAND2_X1 _0643_ (
    .A1(counter[6]),
    .A2(_0173_),
    .ZN(_0174_)
  );
  NAND3_X1 _0644_ (
    .A1(counter[6]),
    .A2(counter[7]),
    .A3(_0173_),
    .ZN(_0175_)
  );
  NOR2_X1 _0645_ (
    .A1(_0071_),
    .A2(_0175_),
    .ZN(_0176_)
  );
  NAND2_X1 _0646_ (
    .A1(counter[9]),
    .A2(_0176_),
    .ZN(_0177_)
  );
  NAND3_X1 _0647_ (
    .A1(counter[3]),
    .A2(counter[4]),
    .A3(_0171_),
    .ZN(_0178_)
  );
  NAND3_X1 _0648_ (
    .A1(counter[9]),
    .A2(counter[10]),
    .A3(_0176_),
    .ZN(_0179_)
  );
  XOR2_X1 _0649_ (
    .A(counter[10]),
    .B(_0177_),
    .Z(_0180_)
  );
  AND3_X1 _0650_ (
    .A1(tx_CS),
    .A2(tx_edge),
    .A3(tx_done),
    .ZN(_0181_)
  );
  NOR2_X1 _0651_ (
    .A1(_0180_),
    .A2(_0181_),
    .ZN(_0015_)
  );
  XNOR2_X1 _0652_ (
    .A(counter[9]),
    .B(_0176_),
    .ZN(_0182_)
  );
  NOR2_X1 _0653_ (
    .A1(_0181_),
    .A2(_0182_),
    .ZN(_0016_)
  );
  XNOR2_X1 _0654_ (
    .A(_0071_),
    .B(_0175_),
    .ZN(_0183_)
  );
  NOR2_X1 _0655_ (
    .A1(_0181_),
    .A2(_0183_),
    .ZN(_0017_)
  );
  XOR2_X1 _0656_ (
    .A(counter[7]),
    .B(_0174_),
    .Z(_0184_)
  );
  NOR2_X1 _0657_ (
    .A1(_0181_),
    .A2(_0184_),
    .ZN(_0018_)
  );
  XNOR2_X1 _0658_ (
    .A(counter[6]),
    .B(_0173_),
    .ZN(_0185_)
  );
  NOR2_X1 _0659_ (
    .A1(_0181_),
    .A2(_0185_),
    .ZN(_0019_)
  );
  AOI211_X1 _0660_ (
    .A(_0173_),
    .B(_0181_),
    .C1(_0178_),
    .C2(_0073_),
    .ZN(_0020_)
  );
  XOR2_X1 _0661_ (
    .A(counter[4]),
    .B(_0172_),
    .Z(_0186_)
  );
  NOR2_X1 _0662_ (
    .A1(_0181_),
    .A2(_0186_),
    .ZN(_0021_)
  );
  XNOR2_X1 _0663_ (
    .A(counter[3]),
    .B(_0171_),
    .ZN(_0187_)
  );
  NOR2_X1 _0664_ (
    .A1(_0181_),
    .A2(_0187_),
    .ZN(_0022_)
  );
  AOI21_X1 _0665_ (
    .A(counter[2]),
    .B1(_0170_),
    .B2(counter[1]),
    .ZN(_0188_)
  );
  NOR3_X1 _0666_ (
    .A1(_0171_),
    .A2(_0181_),
    .A3(_0188_),
    .ZN(_0023_)
  );
  XNOR2_X1 _0667_ (
    .A(counter[1]),
    .B(_0170_),
    .ZN(_0189_)
  );
  NOR2_X1 _0668_ (
    .A1(_0181_),
    .A2(_0189_),
    .ZN(_0024_)
  );
  AOI21_X1 _0669_ (
    .A(counter[0]),
    .B1(tx_edge),
    .B2(tx_CS),
    .ZN(_0190_)
  );
  NOR3_X1 _0670_ (
    .A1(_0170_),
    .A2(_0181_),
    .A3(_0190_),
    .ZN(_0025_)
  );
  NOR2_X1 _0671_ (
    .A1(data_int[30]),
    .A2(_0154_),
    .ZN(_0191_)
  );
  MUX2_X1 _0672_ (
    .A(data_int[29]),
    .B(data_int[26]),
    .S(en_quad_in),
    .Z(_0192_)
  );
  MUX2_X1 _0673_ (
    .A(_0192_),
    .B(data[30]),
    .S(_0150_),
    .Z(_0193_)
  );
  OR2_X1 _0674_ (
    .A1(_0141_),
    .A2(_0192_),
    .ZN(_0194_)
  );
  OAI21_X1 _0675_ (
    .A(_0194_),
    .B1(_0142_),
    .B2(data[30]),
    .ZN(_0195_)
  );
  NAND4_X1 _0676_ (
    .A1(_0101_),
    .A2(_0133_),
    .A3(_0143_),
    .A4(_0195_),
    .ZN(_0196_)
  );
  OAI211_X1 _0677_ (
    .A(tx_CS),
    .B(_0196_),
    .C1(_0193_),
    .C2(_0145_),
    .ZN(_0197_)
  );
  OAI21_X1 _0678_ (
    .A(_0149_),
    .B1(_0148_),
    .B2(data[30]),
    .ZN(_0198_)
  );
  AOI21_X1 _0679_ (
    .A(_0191_),
    .B1(_0197_),
    .B2(_0198_),
    .ZN(_0026_)
  );
  NOR2_X1 _0680_ (
    .A1(data_int[29]),
    .A2(_0154_),
    .ZN(_0199_)
  );
  MUX2_X1 _0681_ (
    .A(data_int[28]),
    .B(data_int[25]),
    .S(en_quad_in),
    .Z(_0200_)
  );
  MUX2_X1 _0682_ (
    .A(_0200_),
    .B(data[29]),
    .S(_0150_),
    .Z(_0201_)
  );
  AND2_X1 _0683_ (
    .A1(_0142_),
    .A2(_0200_),
    .ZN(_0202_)
  );
  AOI21_X1 _0684_ (
    .A(_0202_),
    .B1(_0141_),
    .B2(data[29]),
    .ZN(_0203_)
  );
  NAND4_X1 _0685_ (
    .A1(_0101_),
    .A2(_0133_),
    .A3(_0143_),
    .A4(_0203_),
    .ZN(_0204_)
  );
  OAI211_X1 _0686_ (
    .A(tx_CS),
    .B(_0204_),
    .C1(_0201_),
    .C2(_0145_),
    .ZN(_0205_)
  );
  OAI21_X1 _0687_ (
    .A(_0149_),
    .B1(_0148_),
    .B2(data[29]),
    .ZN(_0206_)
  );
  AOI21_X1 _0688_ (
    .A(_0199_),
    .B1(_0205_),
    .B2(_0206_),
    .ZN(_0027_)
  );
  NOR2_X1 _0689_ (
    .A1(data_int[28]),
    .A2(_0154_),
    .ZN(_0207_)
  );
  MUX2_X1 _0690_ (
    .A(data_int[27]),
    .B(data_int[24]),
    .S(en_quad_in),
    .Z(_0208_)
  );
  MUX2_X1 _0691_ (
    .A(_0208_),
    .B(data[28]),
    .S(_0150_),
    .Z(_0209_)
  );
  OR2_X1 _0692_ (
    .A1(_0141_),
    .A2(_0208_),
    .ZN(_0210_)
  );
  OAI21_X1 _0693_ (
    .A(_0210_),
    .B1(_0142_),
    .B2(data[28]),
    .ZN(_0211_)
  );
  NAND4_X1 _0694_ (
    .A1(_0101_),
    .A2(_0133_),
    .A3(_0143_),
    .A4(_0211_),
    .ZN(_0212_)
  );
  OAI211_X1 _0695_ (
    .A(tx_CS),
    .B(_0212_),
    .C1(_0209_),
    .C2(_0145_),
    .ZN(_0213_)
  );
  OAI21_X1 _0696_ (
    .A(_0149_),
    .B1(_0148_),
    .B2(data[28]),
    .ZN(_0214_)
  );
  AOI21_X1 _0697_ (
    .A(_0207_),
    .B1(_0213_),
    .B2(_0214_),
    .ZN(_0028_)
  );
  NOR2_X1 _0698_ (
    .A1(data_int[27]),
    .A2(_0154_),
    .ZN(_0215_)
  );
  MUX2_X1 _0699_ (
    .A(data_int[26]),
    .B(data_int[23]),
    .S(en_quad_in),
    .Z(_0216_)
  );
  MUX2_X1 _0700_ (
    .A(_0216_),
    .B(data[27]),
    .S(_0150_),
    .Z(_0217_)
  );
  OR2_X1 _0701_ (
    .A1(_0141_),
    .A2(_0216_),
    .ZN(_0218_)
  );
  OAI21_X1 _0702_ (
    .A(_0218_),
    .B1(_0142_),
    .B2(data[27]),
    .ZN(_0219_)
  );
  NAND4_X1 _0703_ (
    .A1(_0101_),
    .A2(_0133_),
    .A3(_0143_),
    .A4(_0219_),
    .ZN(_0220_)
  );
  OAI211_X1 _0704_ (
    .A(tx_CS),
    .B(_0220_),
    .C1(_0217_),
    .C2(_0145_),
    .ZN(_0221_)
  );
  OAI21_X1 _0705_ (
    .A(_0149_),
    .B1(_0148_),
    .B2(data[27]),
    .ZN(_0222_)
  );
  AOI21_X1 _0706_ (
    .A(_0215_),
    .B1(_0221_),
    .B2(_0222_),
    .ZN(_0029_)
  );
  OAI22_X1 _0707_ (
    .A1(_0070_),
    .A2(counter_in_upd),
    .B1(_0155_),
    .B2(_0083_),
    .ZN(_0030_)
  );
  NOR2_X1 _0708_ (
    .A1(data_int[26]),
    .A2(_0154_),
    .ZN(_0223_)
  );
  MUX2_X1 _0709_ (
    .A(data_int[25]),
    .B(data_int[22]),
    .S(en_quad_in),
    .Z(_0224_)
  );
  MUX2_X1 _0710_ (
    .A(_0224_),
    .B(data[26]),
    .S(_0150_),
    .Z(_0225_)
  );
  OR2_X1 _0711_ (
    .A1(_0141_),
    .A2(_0224_),
    .ZN(_0226_)
  );
  OAI21_X1 _0712_ (
    .A(_0226_),
    .B1(_0142_),
    .B2(data[26]),
    .ZN(_0227_)
  );
  NAND4_X1 _0713_ (
    .A1(_0101_),
    .A2(_0133_),
    .A3(_0143_),
    .A4(_0227_),
    .ZN(_0228_)
  );
  OAI211_X1 _0714_ (
    .A(tx_CS),
    .B(_0228_),
    .C1(_0225_),
    .C2(_0145_),
    .ZN(_0229_)
  );
  OAI21_X1 _0715_ (
    .A(_0149_),
    .B1(_0148_),
    .B2(data[26]),
    .ZN(_0230_)
  );
  AOI21_X1 _0716_ (
    .A(_0223_),
    .B1(_0229_),
    .B2(_0230_),
    .ZN(_0031_)
  );
  NOR2_X1 _0717_ (
    .A1(data_int[25]),
    .A2(_0154_),
    .ZN(_0231_)
  );
  MUX2_X1 _0718_ (
    .A(data_int[24]),
    .B(data_int[21]),
    .S(en_quad_in),
    .Z(_0232_)
  );
  MUX2_X1 _0719_ (
    .A(_0232_),
    .B(data[25]),
    .S(_0150_),
    .Z(_0233_)
  );
  AND2_X1 _0720_ (
    .A1(_0142_),
    .A2(_0232_),
    .ZN(_0234_)
  );
  AOI21_X1 _0721_ (
    .A(_0234_),
    .B1(_0141_),
    .B2(data[25]),
    .ZN(_0235_)
  );
  NAND4_X1 _0722_ (
    .A1(_0101_),
    .A2(_0133_),
    .A3(_0143_),
    .A4(_0235_),
    .ZN(_0236_)
  );
  OAI211_X1 _0723_ (
    .A(tx_CS),
    .B(_0236_),
    .C1(_0233_),
    .C2(_0145_),
    .ZN(_0237_)
  );
  OAI21_X1 _0724_ (
    .A(_0149_),
    .B1(_0148_),
    .B2(data[25]),
    .ZN(_0238_)
  );
  AOI21_X1 _0725_ (
    .A(_0231_),
    .B1(_0237_),
    .B2(_0238_),
    .ZN(_0032_)
  );
  NOR2_X1 _0726_ (
    .A1(data_int[24]),
    .A2(_0154_),
    .ZN(_0239_)
  );
  MUX2_X1 _0727_ (
    .A(data_int[23]),
    .B(data_int[20]),
    .S(en_quad_in),
    .Z(_0240_)
  );
  MUX2_X1 _0728_ (
    .A(_0240_),
    .B(data[24]),
    .S(_0150_),
    .Z(_0241_)
  );
  OR2_X1 _0729_ (
    .A1(_0141_),
    .A2(_0240_),
    .ZN(_0242_)
  );
  OAI21_X1 _0730_ (
    .A(_0242_),
    .B1(_0142_),
    .B2(data[24]),
    .ZN(_0243_)
  );
  NAND4_X1 _0731_ (
    .A1(_0101_),
    .A2(_0133_),
    .A3(_0143_),
    .A4(_0243_),
    .ZN(_0244_)
  );
  OAI211_X1 _0732_ (
    .A(tx_CS),
    .B(_0244_),
    .C1(_0241_),
    .C2(_0145_),
    .ZN(_0245_)
  );
  OAI21_X1 _0733_ (
    .A(_0149_),
    .B1(_0148_),
    .B2(data[24]),
    .ZN(_0246_)
  );
  AOI21_X1 _0734_ (
    .A(_0239_),
    .B1(_0245_),
    .B2(_0246_),
    .ZN(_0033_)
  );
  NOR2_X1 _0735_ (
    .A1(data_int[23]),
    .A2(_0154_),
    .ZN(_0247_)
  );
  MUX2_X1 _0736_ (
    .A(data_int[22]),
    .B(data_int[19]),
    .S(en_quad_in),
    .Z(_0248_)
  );
  MUX2_X1 _0737_ (
    .A(_0248_),
    .B(data[23]),
    .S(_0150_),
    .Z(_0249_)
  );
  OR2_X1 _0738_ (
    .A1(_0141_),
    .A2(_0248_),
    .ZN(_0250_)
  );
  OAI21_X1 _0739_ (
    .A(_0250_),
    .B1(_0142_),
    .B2(data[23]),
    .ZN(_0251_)
  );
  NAND4_X1 _0740_ (
    .A1(_0101_),
    .A2(_0133_),
    .A3(_0143_),
    .A4(_0251_),
    .ZN(_0252_)
  );
  OAI211_X1 _0741_ (
    .A(tx_CS),
    .B(_0252_),
    .C1(_0249_),
    .C2(_0145_),
    .ZN(_0253_)
  );
  OAI21_X1 _0742_ (
    .A(_0149_),
    .B1(_0148_),
    .B2(data[23]),
    .ZN(_0254_)
  );
  AOI21_X1 _0743_ (
    .A(_0247_),
    .B1(_0253_),
    .B2(_0254_),
    .ZN(_0034_)
  );
  NOR2_X1 _0744_ (
    .A1(data_int[22]),
    .A2(_0154_),
    .ZN(_0255_)
  );
  MUX2_X1 _0745_ (
    .A(data_int[21]),
    .B(data_int[18]),
    .S(en_quad_in),
    .Z(_0256_)
  );
  MUX2_X1 _0746_ (
    .A(_0256_),
    .B(data[22]),
    .S(_0150_),
    .Z(_0257_)
  );
  OR2_X1 _0747_ (
    .A1(_0141_),
    .A2(_0256_),
    .ZN(_0258_)
  );
  OAI21_X1 _0748_ (
    .A(_0258_),
    .B1(_0142_),
    .B2(data[22]),
    .ZN(_0259_)
  );
  NAND4_X1 _0749_ (
    .A1(_0101_),
    .A2(_0133_),
    .A3(_0143_),
    .A4(_0259_),
    .ZN(_0260_)
  );
  OAI211_X1 _0750_ (
    .A(tx_CS),
    .B(_0260_),
    .C1(_0257_),
    .C2(_0145_),
    .ZN(_0261_)
  );
  OAI21_X1 _0751_ (
    .A(_0149_),
    .B1(_0148_),
    .B2(data[22]),
    .ZN(_0262_)
  );
  AOI21_X1 _0752_ (
    .A(_0255_),
    .B1(_0261_),
    .B2(_0262_),
    .ZN(_0035_)
  );
  NOR2_X1 _0753_ (
    .A1(data_int[21]),
    .A2(_0154_),
    .ZN(_0263_)
  );
  MUX2_X1 _0754_ (
    .A(data_int[20]),
    .B(data_int[17]),
    .S(en_quad_in),
    .Z(_0264_)
  );
  MUX2_X1 _0755_ (
    .A(_0264_),
    .B(data[21]),
    .S(_0150_),
    .Z(_0265_)
  );
  OR2_X1 _0756_ (
    .A1(_0141_),
    .A2(_0264_),
    .ZN(_0266_)
  );
  OAI21_X1 _0757_ (
    .A(_0266_),
    .B1(_0142_),
    .B2(data[21]),
    .ZN(_0267_)
  );
  NAND4_X1 _0758_ (
    .A1(_0101_),
    .A2(_0133_),
    .A3(_0143_),
    .A4(_0267_),
    .ZN(_0268_)
  );
  OAI211_X1 _0759_ (
    .A(tx_CS),
    .B(_0268_),
    .C1(_0265_),
    .C2(_0145_),
    .ZN(_0269_)
  );
  OAI21_X1 _0760_ (
    .A(_0149_),
    .B1(_0148_),
    .B2(data[21]),
    .ZN(_0270_)
  );
  AOI21_X1 _0761_ (
    .A(_0263_),
    .B1(_0269_),
    .B2(_0270_),
    .ZN(_0036_)
  );
  NOR2_X1 _0762_ (
    .A1(data_int[20]),
    .A2(_0154_),
    .ZN(_0271_)
  );
  MUX2_X1 _0763_ (
    .A(data_int[19]),
    .B(data_int[16]),
    .S(en_quad_in),
    .Z(_0272_)
  );
  MUX2_X1 _0764_ (
    .A(_0272_),
    .B(data[20]),
    .S(_0150_),
    .Z(_0273_)
  );
  OR2_X1 _0765_ (
    .A1(_0141_),
    .A2(_0272_),
    .ZN(_0274_)
  );
  OAI21_X1 _0766_ (
    .A(_0274_),
    .B1(_0142_),
    .B2(data[20]),
    .ZN(_0275_)
  );
  NAND4_X1 _0767_ (
    .A1(_0101_),
    .A2(_0133_),
    .A3(_0143_),
    .A4(_0275_),
    .ZN(_0276_)
  );
  OAI211_X1 _0768_ (
    .A(tx_CS),
    .B(_0276_),
    .C1(_0273_),
    .C2(_0145_),
    .ZN(_0277_)
  );
  OAI21_X1 _0769_ (
    .A(_0149_),
    .B1(_0148_),
    .B2(data[20]),
    .ZN(_0278_)
  );
  AOI21_X1 _0770_ (
    .A(_0271_),
    .B1(_0277_),
    .B2(_0278_),
    .ZN(_0037_)
  );
  NOR2_X1 _0771_ (
    .A1(data_int[19]),
    .A2(_0154_),
    .ZN(_0279_)
  );
  MUX2_X1 _0772_ (
    .A(data_int[18]),
    .B(data_int[15]),
    .S(en_quad_in),
    .Z(_0280_)
  );
  MUX2_X1 _0773_ (
    .A(_0280_),
    .B(data[19]),
    .S(_0150_),
    .Z(_0281_)
  );
  OR2_X1 _0774_ (
    .A1(_0141_),
    .A2(_0280_),
    .ZN(_0282_)
  );
  OAI21_X1 _0775_ (
    .A(_0282_),
    .B1(_0142_),
    .B2(data[19]),
    .ZN(_0283_)
  );
  NAND4_X1 _0776_ (
    .A1(_0101_),
    .A2(_0133_),
    .A3(_0143_),
    .A4(_0283_),
    .ZN(_0284_)
  );
  OAI211_X1 _0777_ (
    .A(tx_CS),
    .B(_0284_),
    .C1(_0281_),
    .C2(_0145_),
    .ZN(_0285_)
  );
  OAI21_X1 _0778_ (
    .A(_0149_),
    .B1(_0148_),
    .B2(data[19]),
    .ZN(_0286_)
  );
  AOI21_X1 _0779_ (
    .A(_0279_),
    .B1(_0285_),
    .B2(_0286_),
    .ZN(_0038_)
  );
  NOR2_X1 _0780_ (
    .A1(data_int[18]),
    .A2(_0154_),
    .ZN(_0287_)
  );
  MUX2_X1 _0781_ (
    .A(data_int[17]),
    .B(data_int[14]),
    .S(en_quad_in),
    .Z(_0288_)
  );
  MUX2_X1 _0782_ (
    .A(_0288_),
    .B(data[18]),
    .S(_0150_),
    .Z(_0289_)
  );
  OR2_X1 _0783_ (
    .A1(_0141_),
    .A2(_0288_),
    .ZN(_0290_)
  );
  OAI21_X1 _0784_ (
    .A(_0290_),
    .B1(_0142_),
    .B2(data[18]),
    .ZN(_0291_)
  );
  NAND4_X1 _0785_ (
    .A1(_0101_),
    .A2(_0133_),
    .A3(_0143_),
    .A4(_0291_),
    .ZN(_0292_)
  );
  OAI211_X1 _0786_ (
    .A(tx_CS),
    .B(_0292_),
    .C1(_0289_),
    .C2(_0145_),
    .ZN(_0293_)
  );
  OAI21_X1 _0787_ (
    .A(_0149_),
    .B1(_0148_),
    .B2(data[18]),
    .ZN(_0294_)
  );
  AOI21_X1 _0788_ (
    .A(_0287_),
    .B1(_0293_),
    .B2(_0294_),
    .ZN(_0039_)
  );
  NOR2_X1 _0789_ (
    .A1(data_int[17]),
    .A2(_0154_),
    .ZN(_0295_)
  );
  MUX2_X1 _0790_ (
    .A(data_int[16]),
    .B(data_int[13]),
    .S(en_quad_in),
    .Z(_0296_)
  );
  MUX2_X1 _0791_ (
    .A(_0296_),
    .B(data[17]),
    .S(_0150_),
    .Z(_0297_)
  );
  OR2_X1 _0792_ (
    .A1(_0141_),
    .A2(_0296_),
    .ZN(_0298_)
  );
  OAI21_X1 _0793_ (
    .A(_0298_),
    .B1(_0142_),
    .B2(data[17]),
    .ZN(_0299_)
  );
  NAND4_X1 _0794_ (
    .A1(_0101_),
    .A2(_0133_),
    .A3(_0143_),
    .A4(_0299_),
    .ZN(_0300_)
  );
  OAI211_X1 _0795_ (
    .A(tx_CS),
    .B(_0300_),
    .C1(_0297_),
    .C2(_0145_),
    .ZN(_0301_)
  );
  OAI21_X1 _0796_ (
    .A(_0149_),
    .B1(_0148_),
    .B2(data[17]),
    .ZN(_0302_)
  );
  AOI21_X1 _0797_ (
    .A(_0295_),
    .B1(_0301_),
    .B2(_0302_),
    .ZN(_0040_)
  );
  NOR2_X1 _0798_ (
    .A1(data_int[31]),
    .A2(_0154_),
    .ZN(_0303_)
  );
  MUX2_X1 _0799_ (
    .A(data_int[30]),
    .B(data_int[27]),
    .S(en_quad_in),
    .Z(_0304_)
  );
  MUX2_X1 _0800_ (
    .A(_0304_),
    .B(data[31]),
    .S(_0150_),
    .Z(_0305_)
  );
  OR2_X1 _0801_ (
    .A1(_0141_),
    .A2(_0304_),
    .ZN(_0306_)
  );
  OAI21_X1 _0802_ (
    .A(_0306_),
    .B1(_0142_),
    .B2(data[31]),
    .ZN(_0307_)
  );
  NAND4_X1 _0803_ (
    .A1(_0101_),
    .A2(_0133_),
    .A3(_0143_),
    .A4(_0307_),
    .ZN(_0308_)
  );
  OAI211_X1 _0804_ (
    .A(tx_CS),
    .B(_0308_),
    .C1(_0305_),
    .C2(_0145_),
    .ZN(_0309_)
  );
  OAI21_X1 _0805_ (
    .A(_0149_),
    .B1(_0148_),
    .B2(data[31]),
    .ZN(_0310_)
  );
  AOI21_X1 _0806_ (
    .A(_0303_),
    .B1(_0309_),
    .B2(_0310_),
    .ZN(_0041_)
  );
  NOR2_X1 _0807_ (
    .A1(data_int[16]),
    .A2(_0154_),
    .ZN(_0311_)
  );
  MUX2_X1 _0808_ (
    .A(data_int[15]),
    .B(data_int[12]),
    .S(en_quad_in),
    .Z(_0312_)
  );
  MUX2_X1 _0809_ (
    .A(_0312_),
    .B(data[16]),
    .S(_0150_),
    .Z(_0313_)
  );
  OR2_X1 _0810_ (
    .A1(_0141_),
    .A2(_0312_),
    .ZN(_0314_)
  );
  OAI21_X1 _0811_ (
    .A(_0314_),
    .B1(_0142_),
    .B2(data[16]),
    .ZN(_0315_)
  );
  NAND4_X1 _0812_ (
    .A1(_0101_),
    .A2(_0133_),
    .A3(_0143_),
    .A4(_0315_),
    .ZN(_0316_)
  );
  OAI211_X1 _0813_ (
    .A(tx_CS),
    .B(_0316_),
    .C1(_0313_),
    .C2(_0145_),
    .ZN(_0317_)
  );
  OAI21_X1 _0814_ (
    .A(_0149_),
    .B1(_0148_),
    .B2(data[16]),
    .ZN(_0318_)
  );
  AOI21_X1 _0815_ (
    .A(_0311_),
    .B1(_0317_),
    .B2(_0318_),
    .ZN(_0042_)
  );
  NOR2_X1 _0816_ (
    .A1(data_int[15]),
    .A2(_0154_),
    .ZN(_0319_)
  );
  MUX2_X1 _0817_ (
    .A(data_int[14]),
    .B(data_int[11]),
    .S(en_quad_in),
    .Z(_0320_)
  );
  MUX2_X1 _0818_ (
    .A(_0320_),
    .B(data[15]),
    .S(_0150_),
    .Z(_0321_)
  );
  OR2_X1 _0819_ (
    .A1(_0141_),
    .A2(_0320_),
    .ZN(_0322_)
  );
  OAI21_X1 _0820_ (
    .A(_0322_),
    .B1(_0142_),
    .B2(data[15]),
    .ZN(_0323_)
  );
  NAND4_X1 _0821_ (
    .A1(_0101_),
    .A2(_0133_),
    .A3(_0143_),
    .A4(_0323_),
    .ZN(_0324_)
  );
  OAI211_X1 _0822_ (
    .A(tx_CS),
    .B(_0324_),
    .C1(_0321_),
    .C2(_0145_),
    .ZN(_0325_)
  );
  OAI21_X1 _0823_ (
    .A(_0149_),
    .B1(_0148_),
    .B2(data[15]),
    .ZN(_0326_)
  );
  AOI21_X1 _0824_ (
    .A(_0319_),
    .B1(_0325_),
    .B2(_0326_),
    .ZN(_0043_)
  );
  NOR2_X1 _0825_ (
    .A1(data_int[14]),
    .A2(_0154_),
    .ZN(_0327_)
  );
  MUX2_X1 _0826_ (
    .A(data_int[13]),
    .B(data_int[10]),
    .S(en_quad_in),
    .Z(_0328_)
  );
  MUX2_X1 _0827_ (
    .A(_0328_),
    .B(data[14]),
    .S(_0150_),
    .Z(_0329_)
  );
  OR2_X1 _0828_ (
    .A1(_0141_),
    .A2(_0328_),
    .ZN(_0330_)
  );
  OAI21_X1 _0829_ (
    .A(_0330_),
    .B1(_0142_),
    .B2(data[14]),
    .ZN(_0331_)
  );
  NAND4_X1 _0830_ (
    .A1(_0101_),
    .A2(_0133_),
    .A3(_0143_),
    .A4(_0331_),
    .ZN(_0332_)
  );
  OAI211_X1 _0831_ (
    .A(tx_CS),
    .B(_0332_),
    .C1(_0329_),
    .C2(_0145_),
    .ZN(_0333_)
  );
  OAI21_X1 _0832_ (
    .A(_0149_),
    .B1(_0148_),
    .B2(data[14]),
    .ZN(_0334_)
  );
  AOI21_X1 _0833_ (
    .A(_0327_),
    .B1(_0333_),
    .B2(_0334_),
    .ZN(_0044_)
  );
  NOR2_X1 _0834_ (
    .A1(data_int[13]),
    .A2(_0154_),
    .ZN(_0335_)
  );
  MUX2_X1 _0835_ (
    .A(data_int[12]),
    .B(data_int[9]),
    .S(en_quad_in),
    .Z(_0336_)
  );
  MUX2_X1 _0836_ (
    .A(_0336_),
    .B(data[13]),
    .S(_0150_),
    .Z(_0337_)
  );
  OR2_X1 _0837_ (
    .A1(_0141_),
    .A2(_0336_),
    .ZN(_0338_)
  );
  OAI21_X1 _0838_ (
    .A(_0338_),
    .B1(_0142_),
    .B2(data[13]),
    .ZN(_0339_)
  );
  NAND4_X1 _0839_ (
    .A1(_0101_),
    .A2(_0133_),
    .A3(_0143_),
    .A4(_0339_),
    .ZN(_0340_)
  );
  OAI211_X1 _0840_ (
    .A(tx_CS),
    .B(_0340_),
    .C1(_0337_),
    .C2(_0145_),
    .ZN(_0341_)
  );
  OAI21_X1 _0841_ (
    .A(_0149_),
    .B1(_0148_),
    .B2(data[13]),
    .ZN(_0342_)
  );
  AOI21_X1 _0842_ (
    .A(_0335_),
    .B1(_0341_),
    .B2(_0342_),
    .ZN(_0045_)
  );
  NOR2_X1 _0843_ (
    .A1(data_int[12]),
    .A2(_0154_),
    .ZN(_0343_)
  );
  MUX2_X1 _0844_ (
    .A(data_int[11]),
    .B(data_int[8]),
    .S(en_quad_in),
    .Z(_0344_)
  );
  MUX2_X1 _0845_ (
    .A(_0344_),
    .B(data[12]),
    .S(_0150_),
    .Z(_0345_)
  );
  OR2_X1 _0846_ (
    .A1(_0141_),
    .A2(_0344_),
    .ZN(_0346_)
  );
  OAI21_X1 _0847_ (
    .A(_0346_),
    .B1(_0142_),
    .B2(data[12]),
    .ZN(_0347_)
  );
  NAND4_X1 _0848_ (
    .A1(_0101_),
    .A2(_0133_),
    .A3(_0143_),
    .A4(_0347_),
    .ZN(_0348_)
  );
  OAI211_X1 _0849_ (
    .A(tx_CS),
    .B(_0348_),
    .C1(_0345_),
    .C2(_0145_),
    .ZN(_0349_)
  );
  OAI21_X1 _0850_ (
    .A(_0149_),
    .B1(_0148_),
    .B2(data[12]),
    .ZN(_0350_)
  );
  AOI21_X1 _0851_ (
    .A(_0343_),
    .B1(_0349_),
    .B2(_0350_),
    .ZN(_0046_)
  );
  NOR2_X1 _0852_ (
    .A1(data_int[11]),
    .A2(_0154_),
    .ZN(_0351_)
  );
  MUX2_X1 _0853_ (
    .A(data_int[10]),
    .B(data_int[7]),
    .S(en_quad_in),
    .Z(_0352_)
  );
  MUX2_X1 _0854_ (
    .A(_0352_),
    .B(data[11]),
    .S(_0150_),
    .Z(_0353_)
  );
  OR2_X1 _0855_ (
    .A1(_0141_),
    .A2(_0352_),
    .ZN(_0354_)
  );
  OAI21_X1 _0856_ (
    .A(_0354_),
    .B1(_0142_),
    .B2(data[11]),
    .ZN(_0355_)
  );
  NAND4_X1 _0857_ (
    .A1(_0101_),
    .A2(_0133_),
    .A3(_0143_),
    .A4(_0355_),
    .ZN(_0356_)
  );
  OAI211_X1 _0858_ (
    .A(tx_CS),
    .B(_0356_),
    .C1(_0353_),
    .C2(_0145_),
    .ZN(_0357_)
  );
  OAI21_X1 _0859_ (
    .A(_0149_),
    .B1(_0148_),
    .B2(data[11]),
    .ZN(_0358_)
  );
  AOI21_X1 _0860_ (
    .A(_0351_),
    .B1(_0357_),
    .B2(_0358_),
    .ZN(_0047_)
  );
  NOR2_X1 _0861_ (
    .A1(_0074_),
    .A2(_0179_),
    .ZN(_0359_)
  );
  NAND2_X1 _0862_ (
    .A1(counter[12]),
    .A2(_0359_),
    .ZN(_0360_)
  );
  NAND3_X1 _0863_ (
    .A1(counter[13]),
    .A2(counter[12]),
    .A3(_0359_),
    .ZN(_0361_)
  );
  NAND4_X1 _0864_ (
    .A1(counter[13]),
    .A2(counter[12]),
    .A3(counter[14]),
    .A4(_0359_),
    .ZN(_0362_)
  );
  XNOR2_X1 _0865_ (
    .A(_0075_),
    .B(_0362_),
    .ZN(_0363_)
  );
  NOR2_X1 _0866_ (
    .A1(_0181_),
    .A2(_0363_),
    .ZN(_0048_)
  );
  NOR2_X1 _0867_ (
    .A1(data_int[10]),
    .A2(_0154_),
    .ZN(_0364_)
  );
  MUX2_X1 _0868_ (
    .A(data_int[9]),
    .B(data_int[6]),
    .S(en_quad_in),
    .Z(_0365_)
  );
  MUX2_X1 _0869_ (
    .A(_0365_),
    .B(data[10]),
    .S(_0150_),
    .Z(_0366_)
  );
  AND2_X1 _0870_ (
    .A1(_0142_),
    .A2(_0365_),
    .ZN(_0367_)
  );
  AOI21_X1 _0871_ (
    .A(_0367_),
    .B1(_0141_),
    .B2(data[10]),
    .ZN(_0368_)
  );
  NAND4_X1 _0872_ (
    .A1(_0101_),
    .A2(_0133_),
    .A3(_0143_),
    .A4(_0368_),
    .ZN(_0369_)
  );
  OAI211_X1 _0873_ (
    .A(tx_CS),
    .B(_0369_),
    .C1(_0366_),
    .C2(_0145_),
    .ZN(_0370_)
  );
  OAI21_X1 _0874_ (
    .A(_0149_),
    .B1(_0148_),
    .B2(data[10]),
    .ZN(_0371_)
  );
  AOI21_X1 _0875_ (
    .A(_0364_),
    .B1(_0370_),
    .B2(_0371_),
    .ZN(_0049_)
  );
  NOR2_X1 _0876_ (
    .A1(data_int[9]),
    .A2(_0154_),
    .ZN(_0372_)
  );
  MUX2_X1 _0877_ (
    .A(data_int[8]),
    .B(data_int[5]),
    .S(en_quad_in),
    .Z(_0373_)
  );
  MUX2_X1 _0878_ (
    .A(_0373_),
    .B(data[9]),
    .S(_0150_),
    .Z(_0374_)
  );
  AND2_X1 _0879_ (
    .A1(_0142_),
    .A2(_0373_),
    .ZN(_0375_)
  );
  AOI21_X1 _0880_ (
    .A(_0375_),
    .B1(_0141_),
    .B2(data[9]),
    .ZN(_0376_)
  );
  NAND4_X1 _0881_ (
    .A1(_0101_),
    .A2(_0133_),
    .A3(_0143_),
    .A4(_0376_),
    .ZN(_0377_)
  );
  OAI211_X1 _0882_ (
    .A(tx_CS),
    .B(_0377_),
    .C1(_0374_),
    .C2(_0145_),
    .ZN(_0378_)
  );
  OAI21_X1 _0883_ (
    .A(_0149_),
    .B1(_0148_),
    .B2(data[9]),
    .ZN(_0379_)
  );
  AOI21_X1 _0884_ (
    .A(_0372_),
    .B1(_0378_),
    .B2(_0379_),
    .ZN(_0050_)
  );
  NOR2_X1 _0885_ (
    .A1(data_int[8]),
    .A2(_0154_),
    .ZN(_0380_)
  );
  MUX2_X1 _0886_ (
    .A(data_int[7]),
    .B(data_int[4]),
    .S(en_quad_in),
    .Z(_0381_)
  );
  MUX2_X1 _0887_ (
    .A(_0381_),
    .B(data[8]),
    .S(_0150_),
    .Z(_0382_)
  );
  AND2_X1 _0888_ (
    .A1(_0142_),
    .A2(_0381_),
    .ZN(_0383_)
  );
  AOI21_X1 _0889_ (
    .A(_0383_),
    .B1(_0141_),
    .B2(data[8]),
    .ZN(_0384_)
  );
  NAND4_X1 _0890_ (
    .A1(_0101_),
    .A2(_0133_),
    .A3(_0143_),
    .A4(_0384_),
    .ZN(_0385_)
  );
  OAI211_X1 _0891_ (
    .A(tx_CS),
    .B(_0385_),
    .C1(_0382_),
    .C2(_0145_),
    .ZN(_0386_)
  );
  OAI21_X1 _0892_ (
    .A(_0149_),
    .B1(_0148_),
    .B2(data[8]),
    .ZN(_0387_)
  );
  AOI21_X1 _0893_ (
    .A(_0380_),
    .B1(_0386_),
    .B2(_0387_),
    .ZN(_0051_)
  );
  NOR2_X1 _0894_ (
    .A1(data_int[7]),
    .A2(_0154_),
    .ZN(_0388_)
  );
  MUX2_X1 _0895_ (
    .A(data_int[6]),
    .B(data_int[3]),
    .S(en_quad_in),
    .Z(_0389_)
  );
  MUX2_X1 _0896_ (
    .A(_0389_),
    .B(data[7]),
    .S(_0150_),
    .Z(_0390_)
  );
  AND2_X1 _0897_ (
    .A1(_0142_),
    .A2(_0389_),
    .ZN(_0391_)
  );
  AOI21_X1 _0898_ (
    .A(_0391_),
    .B1(_0141_),
    .B2(data[7]),
    .ZN(_0392_)
  );
  NAND4_X1 _0899_ (
    .A1(_0101_),
    .A2(_0133_),
    .A3(_0143_),
    .A4(_0392_),
    .ZN(_0393_)
  );
  OAI211_X1 _0900_ (
    .A(tx_CS),
    .B(_0393_),
    .C1(_0390_),
    .C2(_0145_),
    .ZN(_0394_)
  );
  OAI21_X1 _0901_ (
    .A(_0149_),
    .B1(_0148_),
    .B2(data[7]),
    .ZN(_0395_)
  );
  AOI21_X1 _0902_ (
    .A(_0388_),
    .B1(_0394_),
    .B2(_0395_),
    .ZN(_0052_)
  );
  NOR2_X1 _0903_ (
    .A1(data_int[6]),
    .A2(_0154_),
    .ZN(_0396_)
  );
  MUX2_X1 _0904_ (
    .A(data_int[5]),
    .B(data_int[2]),
    .S(en_quad_in),
    .Z(_0397_)
  );
  MUX2_X1 _0905_ (
    .A(_0397_),
    .B(data[6]),
    .S(_0150_),
    .Z(_0398_)
  );
  OR2_X1 _0906_ (
    .A1(_0141_),
    .A2(_0397_),
    .ZN(_0399_)
  );
  OAI21_X1 _0907_ (
    .A(_0399_),
    .B1(_0142_),
    .B2(data[6]),
    .ZN(_0400_)
  );
  NAND4_X1 _0908_ (
    .A1(_0101_),
    .A2(_0133_),
    .A3(_0143_),
    .A4(_0400_),
    .ZN(_0401_)
  );
  OAI211_X1 _0909_ (
    .A(tx_CS),
    .B(_0401_),
    .C1(_0398_),
    .C2(_0145_),
    .ZN(_0402_)
  );
  OAI21_X1 _0910_ (
    .A(_0149_),
    .B1(_0148_),
    .B2(data[6]),
    .ZN(_0403_)
  );
  AOI21_X1 _0911_ (
    .A(_0396_),
    .B1(_0402_),
    .B2(_0403_),
    .ZN(_0053_)
  );
  NOR2_X1 _0912_ (
    .A1(data_int[5]),
    .A2(_0154_),
    .ZN(_0404_)
  );
  MUX2_X1 _0913_ (
    .A(data_int[4]),
    .B(data_int[1]),
    .S(en_quad_in),
    .Z(_0405_)
  );
  MUX2_X1 _0914_ (
    .A(_0405_),
    .B(data[5]),
    .S(_0150_),
    .Z(_0406_)
  );
  OR2_X1 _0915_ (
    .A1(_0141_),
    .A2(_0405_),
    .ZN(_0407_)
  );
  OAI21_X1 _0916_ (
    .A(_0407_),
    .B1(_0142_),
    .B2(data[5]),
    .ZN(_0408_)
  );
  NAND4_X1 _0917_ (
    .A1(_0101_),
    .A2(_0133_),
    .A3(_0143_),
    .A4(_0408_),
    .ZN(_0409_)
  );
  OAI211_X1 _0918_ (
    .A(tx_CS),
    .B(_0409_),
    .C1(_0406_),
    .C2(_0145_),
    .ZN(_0410_)
  );
  OAI21_X1 _0919_ (
    .A(_0149_),
    .B1(_0148_),
    .B2(data[5]),
    .ZN(_0411_)
  );
  AOI21_X1 _0920_ (
    .A(_0404_),
    .B1(_0410_),
    .B2(_0411_),
    .ZN(_0054_)
  );
  NOR2_X1 _0921_ (
    .A1(data_int[4]),
    .A2(_0154_),
    .ZN(_0412_)
  );
  MUX2_X1 _0922_ (
    .A(data_int[3]),
    .B(data_int[0]),
    .S(en_quad_in),
    .Z(_0413_)
  );
  MUX2_X1 _0923_ (
    .A(_0413_),
    .B(data[4]),
    .S(_0150_),
    .Z(_0414_)
  );
  OR2_X1 _0924_ (
    .A1(_0141_),
    .A2(_0413_),
    .ZN(_0415_)
  );
  OAI21_X1 _0925_ (
    .A(_0415_),
    .B1(_0142_),
    .B2(data[4]),
    .ZN(_0416_)
  );
  NAND4_X1 _0926_ (
    .A1(_0101_),
    .A2(_0133_),
    .A3(_0143_),
    .A4(_0416_),
    .ZN(_0417_)
  );
  OAI211_X1 _0927_ (
    .A(tx_CS),
    .B(_0417_),
    .C1(_0414_),
    .C2(_0145_),
    .ZN(_0418_)
  );
  OAI21_X1 _0928_ (
    .A(_0149_),
    .B1(_0148_),
    .B2(data[4]),
    .ZN(_0419_)
  );
  AOI21_X1 _0929_ (
    .A(_0412_),
    .B1(_0418_),
    .B2(_0419_),
    .ZN(_0055_)
  );
  NOR2_X1 _0930_ (
    .A1(data_int[3]),
    .A2(_0154_),
    .ZN(_0420_)
  );
  AOI21_X1 _0931_ (
    .A(_0150_),
    .B1(data_int[2]),
    .B2(_0066_),
    .ZN(_0421_)
  );
  AOI21_X1 _0932_ (
    .A(_0421_),
    .B1(_0150_),
    .B2(_0079_),
    .ZN(_0422_)
  );
  OAI21_X1 _0933_ (
    .A(_0142_),
    .B1(_0076_),
    .B2(en_quad_in),
    .ZN(_0423_)
  );
  OAI21_X1 _0934_ (
    .A(_0423_),
    .B1(_0142_),
    .B2(data[3]),
    .ZN(_0424_)
  );
  NAND4_X1 _0935_ (
    .A1(_0101_),
    .A2(_0133_),
    .A3(_0143_),
    .A4(_0424_),
    .ZN(_0425_)
  );
  OAI211_X1 _0936_ (
    .A(tx_CS),
    .B(_0425_),
    .C1(_0422_),
    .C2(_0145_),
    .ZN(_0426_)
  );
  OAI21_X1 _0937_ (
    .A(_0149_),
    .B1(_0148_),
    .B2(data[3]),
    .ZN(_0427_)
  );
  AOI21_X1 _0938_ (
    .A(_0420_),
    .B1(_0426_),
    .B2(_0427_),
    .ZN(_0056_)
  );
  AOI21_X1 _0939_ (
    .A(_0150_),
    .B1(data_int[1]),
    .B2(_0066_),
    .ZN(_0428_)
  );
  AOI21_X1 _0940_ (
    .A(_0428_),
    .B1(_0150_),
    .B2(_0080_),
    .ZN(_0429_)
  );
  NOR3_X1 _0941_ (
    .A1(en_quad_in),
    .A2(_0077_),
    .A3(_0141_),
    .ZN(_0430_)
  );
  AOI21_X1 _0942_ (
    .A(_0430_),
    .B1(_0141_),
    .B2(data[2]),
    .ZN(_0431_)
  );
  NAND4_X1 _0943_ (
    .A1(_0101_),
    .A2(_0133_),
    .A3(_0143_),
    .A4(_0431_),
    .ZN(_0432_)
  );
  OAI211_X1 _0944_ (
    .A(tx_CS),
    .B(_0432_),
    .C1(_0429_),
    .C2(_0145_),
    .ZN(_0433_)
  );
  OAI21_X1 _0945_ (
    .A(_0149_),
    .B1(_0148_),
    .B2(data[2]),
    .ZN(_0434_)
  );
  AOI22_X1 _0946_ (
    .A1(_0076_),
    .A2(_0153_),
    .B1(_0433_),
    .B2(_0434_),
    .ZN(_0057_)
  );
  AOI21_X1 _0947_ (
    .A(_0150_),
    .B1(data_int[0]),
    .B2(_0066_),
    .ZN(_0435_)
  );
  AOI21_X1 _0948_ (
    .A(_0435_),
    .B1(_0150_),
    .B2(_0081_),
    .ZN(_0436_)
  );
  OAI21_X1 _0949_ (
    .A(_0142_),
    .B1(_0078_),
    .B2(en_quad_in),
    .ZN(_0437_)
  );
  OAI21_X1 _0950_ (
    .A(_0437_),
    .B1(_0142_),
    .B2(data[1]),
    .ZN(_0438_)
  );
  NAND4_X1 _0951_ (
    .A1(_0101_),
    .A2(_0133_),
    .A3(_0143_),
    .A4(_0438_),
    .ZN(_0439_)
  );
  OAI211_X1 _0952_ (
    .A(tx_CS),
    .B(_0439_),
    .C1(_0436_),
    .C2(_0145_),
    .ZN(_0440_)
  );
  OAI21_X1 _0953_ (
    .A(_0149_),
    .B1(_0148_),
    .B2(data[1]),
    .ZN(_0441_)
  );
  AOI22_X1 _0954_ (
    .A1(_0077_),
    .A2(_0153_),
    .B1(_0440_),
    .B2(_0441_),
    .ZN(_0058_)
  );
  AOI21_X1 _0955_ (
    .A(_0064_),
    .B1(_0146_),
    .B2(_0151_),
    .ZN(_0442_)
  );
  NAND2_X1 _0956_ (
    .A1(data[0]),
    .A2(_0154_),
    .ZN(_0443_)
  );
  OAI22_X1 _0957_ (
    .A1(_0078_),
    .A2(_0154_),
    .B1(_0442_),
    .B2(_0443_),
    .ZN(_0059_)
  );
  XOR2_X1 _0958_ (
    .A(counter[14]),
    .B(_0361_),
    .Z(_0444_)
  );
  NOR2_X1 _0959_ (
    .A1(_0181_),
    .A2(_0444_),
    .ZN(_0060_)
  );
  XOR2_X1 _0960_ (
    .A(counter[13]),
    .B(_0360_),
    .Z(_0445_)
  );
  NOR2_X1 _0961_ (
    .A1(_0181_),
    .A2(_0445_),
    .ZN(_0061_)
  );
  XNOR2_X1 _0962_ (
    .A(counter[12]),
    .B(_0359_),
    .ZN(_0446_)
  );
  NOR2_X1 _0963_ (
    .A1(_0181_),
    .A2(_0446_),
    .ZN(_0062_)
  );
  XNOR2_X1 _0964_ (
    .A(_0074_),
    .B(_0179_),
    .ZN(_0447_)
  );
  NOR2_X1 _0965_ (
    .A1(_0181_),
    .A2(_0447_),
    .ZN(_0063_)
  );
  DFFR_X1 _0966_ (
    .CK(clk),
    .D(_0014_),
    .Q(counter_trgt[0]),
    .QN(_0497_),
    .RN(rstn)
  );
  DFFR_X1 _0967_ (
    .CK(clk),
    .D(_0013_),
    .Q(counter_trgt[1]),
    .QN(_0498_),
    .RN(rstn)
  );
  DFFR_X1 _0968_ (
    .CK(clk),
    .D(_0012_),
    .Q(counter_trgt[2]),
    .QN(_0499_),
    .RN(rstn)
  );
  DFFS_X1 _0969_ (
    .CK(clk),
    .D(_0011_),
    .Q(counter_trgt[3]),
    .QN(_0500_),
    .SN(rstn)
  );
  DFFR_X1 _0970_ (
    .CK(clk),
    .D(_0010_),
    .Q(counter_trgt[4]),
    .QN(_0501_),
    .RN(rstn)
  );
  DFFR_X1 _0971_ (
    .CK(clk),
    .D(_0009_),
    .Q(counter_trgt[5]),
    .QN(_0502_),
    .RN(rstn)
  );
  DFFR_X1 _0972_ (
    .CK(clk),
    .D(_0008_),
    .Q(counter_trgt[6]),
    .QN(_0503_),
    .RN(rstn)
  );
  DFFR_X1 _0973_ (
    .CK(clk),
    .D(_0007_),
    .Q(counter_trgt[7]),
    .QN(_0504_),
    .RN(rstn)
  );
  DFFR_X1 _0974_ (
    .CK(clk),
    .D(_0006_),
    .Q(counter_trgt[8]),
    .QN(_0505_),
    .RN(rstn)
  );
  DFFR_X1 _0975_ (
    .CK(clk),
    .D(_0005_),
    .Q(counter_trgt[9]),
    .QN(_0506_),
    .RN(rstn)
  );
  DFFR_X1 _0976_ (
    .CK(clk),
    .D(_0004_),
    .Q(counter_trgt[10]),
    .QN(_0507_),
    .RN(rstn)
  );
  DFFR_X1 _0977_ (
    .CK(clk),
    .D(_0003_),
    .Q(counter_trgt[11]),
    .QN(_0508_),
    .RN(rstn)
  );
  DFFR_X1 _0978_ (
    .CK(clk),
    .D(_0002_),
    .Q(counter_trgt[12]),
    .QN(_0509_),
    .RN(rstn)
  );
  DFFR_X1 _0979_ (
    .CK(clk),
    .D(_0001_),
    .Q(counter_trgt[13]),
    .QN(_0510_),
    .RN(rstn)
  );
  DFFR_X1 _0980_ (
    .CK(clk),
    .D(_0000_),
    .Q(counter_trgt[14]),
    .QN(_0511_),
    .RN(rstn)
  );
  DFFR_X1 _0981_ (
    .CK(clk),
    .D(_0030_),
    .Q(counter_trgt[15]),
    .QN(_0481_),
    .RN(rstn)
  );
  DFFR_X1 _0982_ (
    .CK(clk),
    .D(_0059_),
    .Q(data_int[0]),
    .QN(_0452_),
    .RN(rstn)
  );
  DFFR_X1 _0983_ (
    .CK(clk),
    .D(_0058_),
    .Q(data_int[1]),
    .QN(_0453_),
    .RN(rstn)
  );
  DFFR_X1 _0984_ (
    .CK(clk),
    .D(_0057_),
    .Q(data_int[2]),
    .QN(_0454_),
    .RN(rstn)
  );
  DFFR_X1 _0985_ (
    .CK(clk),
    .D(_0056_),
    .Q(data_int[3]),
    .QN(_0455_),
    .RN(rstn)
  );
  DFFR_X1 _0986_ (
    .CK(clk),
    .D(_0055_),
    .Q(data_int[4]),
    .QN(_0456_),
    .RN(rstn)
  );
  DFFR_X1 _0987_ (
    .CK(clk),
    .D(_0054_),
    .Q(data_int[5]),
    .QN(_0457_),
    .RN(rstn)
  );
  DFFR_X1 _0988_ (
    .CK(clk),
    .D(_0053_),
    .Q(data_int[6]),
    .QN(_0458_),
    .RN(rstn)
  );
  DFFR_X1 _0989_ (
    .CK(clk),
    .D(_0052_),
    .Q(data_int[7]),
    .QN(_0459_),
    .RN(rstn)
  );
  DFFR_X1 _0990_ (
    .CK(clk),
    .D(_0051_),
    .Q(data_int[8]),
    .QN(_0460_),
    .RN(rstn)
  );
  DFFR_X1 _0991_ (
    .CK(clk),
    .D(_0050_),
    .Q(data_int[9]),
    .QN(_0461_),
    .RN(rstn)
  );
  DFFR_X1 _0992_ (
    .CK(clk),
    .D(_0049_),
    .Q(data_int[10]),
    .QN(_0462_),
    .RN(rstn)
  );
  DFFR_X1 _0993_ (
    .CK(clk),
    .D(_0047_),
    .Q(data_int[11]),
    .QN(_0464_),
    .RN(rstn)
  );
  DFFR_X1 _0994_ (
    .CK(clk),
    .D(_0046_),
    .Q(data_int[12]),
    .QN(_0465_),
    .RN(rstn)
  );
  DFFR_X1 _0995_ (
    .CK(clk),
    .D(_0045_),
    .Q(data_int[13]),
    .QN(_0466_),
    .RN(rstn)
  );
  DFFR_X1 _0996_ (
    .CK(clk),
    .D(_0044_),
    .Q(data_int[14]),
    .QN(_0467_),
    .RN(rstn)
  );
  DFFR_X1 _0997_ (
    .CK(clk),
    .D(_0043_),
    .Q(data_int[15]),
    .QN(_0468_),
    .RN(rstn)
  );
  DFFR_X1 _0998_ (
    .CK(clk),
    .D(_0042_),
    .Q(data_int[16]),
    .QN(_0469_),
    .RN(rstn)
  );
  DFFR_X1 _0999_ (
    .CK(clk),
    .D(_0040_),
    .Q(data_int[17]),
    .QN(_0471_),
    .RN(rstn)
  );
  DFFR_X1 _1000_ (
    .CK(clk),
    .D(_0039_),
    .Q(data_int[18]),
    .QN(_0472_),
    .RN(rstn)
  );
  DFFR_X1 _1001_ (
    .CK(clk),
    .D(_0038_),
    .Q(data_int[19]),
    .QN(_0473_),
    .RN(rstn)
  );
  DFFR_X1 _1002_ (
    .CK(clk),
    .D(_0037_),
    .Q(data_int[20]),
    .QN(_0474_),
    .RN(rstn)
  );
  DFFR_X1 _1003_ (
    .CK(clk),
    .D(_0036_),
    .Q(data_int[21]),
    .QN(_0475_),
    .RN(rstn)
  );
  DFFR_X1 _1004_ (
    .CK(clk),
    .D(_0035_),
    .Q(data_int[22]),
    .QN(_0476_),
    .RN(rstn)
  );
  DFFR_X1 _1005_ (
    .CK(clk),
    .D(_0034_),
    .Q(data_int[23]),
    .QN(_0477_),
    .RN(rstn)
  );
  DFFR_X1 _1006_ (
    .CK(clk),
    .D(_0033_),
    .Q(data_int[24]),
    .QN(_0512_),
    .RN(rstn)
  );
  DFFR_X1 _1007_ (
    .CK(clk),
    .D(_0032_),
    .Q(data_int[25]),
    .QN(_0479_),
    .RN(rstn)
  );
  DFFR_X1 _1008_ (
    .CK(clk),
    .D(_0031_),
    .Q(data_int[26]),
    .QN(_0480_),
    .RN(rstn)
  );
  DFFR_X1 _1009_ (
    .CK(clk),
    .D(_0029_),
    .Q(data_int[27]),
    .QN(_0482_),
    .RN(rstn)
  );
  DFFR_X1 _1010_ (
    .CK(clk),
    .D(_0028_),
    .Q(data_int[28]),
    .QN(_0483_),
    .RN(rstn)
  );
  DFFR_X1 _1011_ (
    .CK(clk),
    .D(_0027_),
    .Q(data_int[29]),
    .QN(_0484_),
    .RN(rstn)
  );
  DFFR_X1 _1012_ (
    .CK(clk),
    .D(_0026_),
    .Q(data_int[30]),
    .QN(_0485_),
    .RN(rstn)
  );
  DFFR_X1 _1013_ (
    .CK(clk),
    .D(_0041_),
    .Q(data_int[31]),
    .QN(_0470_),
    .RN(rstn)
  );
  DFFR_X1 _1014_ (
    .CK(clk),
    .D(_0025_),
    .Q(counter[0]),
    .QN(_0486_),
    .RN(rstn)
  );
  DFFR_X1 _1015_ (
    .CK(clk),
    .D(_0024_),
    .Q(counter[1]),
    .QN(_0487_),
    .RN(rstn)
  );
  DFFR_X1 _1016_ (
    .CK(clk),
    .D(_0023_),
    .Q(counter[2]),
    .QN(_0488_),
    .RN(rstn)
  );
  DFFR_X1 _1017_ (
    .CK(clk),
    .D(_0022_),
    .Q(counter[3]),
    .QN(_0489_),
    .RN(rstn)
  );
  DFFR_X1 _1018_ (
    .CK(clk),
    .D(_0021_),
    .Q(counter[4]),
    .QN(_0490_),
    .RN(rstn)
  );
  DFFR_X1 _1019_ (
    .CK(clk),
    .D(_0020_),
    .Q(counter[5]),
    .QN(_0491_),
    .RN(rstn)
  );
  DFFR_X1 _1020_ (
    .CK(clk),
    .D(_0019_),
    .Q(counter[6]),
    .QN(_0492_),
    .RN(rstn)
  );
  DFFR_X1 _1021_ (
    .CK(clk),
    .D(_0018_),
    .Q(counter[7]),
    .QN(_0493_),
    .RN(rstn)
  );
  DFFR_X1 _1022_ (
    .CK(clk),
    .D(_0017_),
    .Q(counter[8]),
    .QN(_0494_),
    .RN(rstn)
  );
  DFFR_X1 _1023_ (
    .CK(clk),
    .D(_0016_),
    .Q(counter[9]),
    .QN(_0495_),
    .RN(rstn)
  );
  DFFR_X1 _1024_ (
    .CK(clk),
    .D(_0015_),
    .Q(counter[10]),
    .QN(_0496_),
    .RN(rstn)
  );
  DFFR_X1 _1025_ (
    .CK(clk),
    .D(_0063_),
    .Q(counter[11]),
    .QN(_0448_),
    .RN(rstn)
  );
  DFFR_X1 _1026_ (
    .CK(clk),
    .D(_0062_),
    .Q(counter[12]),
    .QN(_0449_),
    .RN(rstn)
  );
  DFFR_X1 _1027_ (
    .CK(clk),
    .D(_0061_),
    .Q(counter[13]),
    .QN(_0450_),
    .RN(rstn)
  );
  DFFR_X1 _1028_ (
    .CK(clk),
    .D(_0060_),
    .Q(counter[14]),
    .QN(_0451_),
    .RN(rstn)
  );
  DFFR_X1 _1029_ (
    .CK(clk),
    .D(_0048_),
    .Q(counter[15]),
    .QN(_0463_),
    .RN(rstn)
  );
  DFFR_X1 _1030_ (
    .CK(clk),
    .D(tx_NS),
    .Q(tx_CS),
    .QN(_0478_),
    .RN(rstn)
  );
  assign done = tx_done;
  assign sdo3 = data_int[31];
  assign sdo2 = data_int[30];
  assign sdo1 = data_int[29];
endmodule
