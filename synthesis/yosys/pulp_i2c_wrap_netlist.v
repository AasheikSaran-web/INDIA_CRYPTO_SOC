module \$paramod\apb_i2c\APB_ADDR_WIDTH=s32'00000000000000000000000000001100 (HCLK, HRESETn, PADDR, PWDATA, PWRITE, PSEL, PENABLE, PRDATA, PREADY, PSLVERR, interrupt_o, scl_pad_i, scl_pad_o, scl_padoen_o, sda_pad_i, sda_pad_o, sda_padoen_o);
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
  output interrupt_o;
  wire interrupt_o;
  input scl_pad_i;
  wire scl_pad_i;
  output scl_pad_o;
  wire scl_pad_o;
  output scl_padoen_o;
  wire scl_padoen_o;
  input sda_pad_i;
  wire sda_pad_i;
  output sda_pad_o;
  wire sda_pad_o;
  output sda_padoen_o;
  wire sda_padoen_o;
  wire _000_;
  wire _001_;
  wire _002_;
  wire [7:0] _003_;
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
  wire ack;
  wire al;
  wire i2c_al;
  wire i2c_busy;
  wire iack;
  wire irq_flag;
  wire [7:0] r_cmd;
  wire [7:0] r_ctrl;
  wire [15:0] r_pre;
  wire [7:0] r_tx;
  wire rd;
  wire rxack;
  wire [3:0] s_apb_addr;
  wire s_core_en;
  wire s_done;
  wire s_ien;
  wire s_irxack;
  wire [7:0] s_rx;
  wire [7:0] s_status;
  wire sta;
  wire sto;
  wire tip;
  wire wr;
  INV_X1 _126_ (
    .A(PADDR[4]),
    .ZN(_038_)
  );
  INV_X1 _127_ (
    .A(PADDR[3]),
    .ZN(_039_)
  );
  INV_X1 _128_ (
    .A(PADDR[2]),
    .ZN(_040_)
  );
  INV_X1 _129_ (
    .A(irq_flag),
    .ZN(_041_)
  );
  INV_X1 _130_ (
    .A(i2c_al),
    .ZN(_042_)
  );
  INV_X1 _131_ (
    .A(al),
    .ZN(_043_)
  );
  NOR4_X1 _132_ (
    .A1(PADDR[4]),
    .A2(PADDR[5]),
    .A3(_039_),
    .A4(PADDR[2]),
    .ZN(_044_)
  );
  NOR4_X1 _133_ (
    .A1(PADDR[4]),
    .A2(PADDR[5]),
    .A3(PADDR[3]),
    .A4(PADDR[2]),
    .ZN(_045_)
  );
  NOR4_X1 _134_ (
    .A1(_038_),
    .A2(PADDR[5]),
    .A3(PADDR[3]),
    .A4(PADDR[2]),
    .ZN(_046_)
  );
  AOI22_X1 _135_ (
    .A1(r_pre[3]),
    .A2(_045_),
    .B1(_046_),
    .B2(r_tx[3]),
    .ZN(_047_)
  );
  NOR4_X1 _136_ (
    .A1(PADDR[4]),
    .A2(PADDR[5]),
    .A3(PADDR[3]),
    .A4(_040_),
    .ZN(_048_)
  );
  NOR4_X1 _137_ (
    .A1(_038_),
    .A2(PADDR[5]),
    .A3(PADDR[3]),
    .A4(_040_),
    .ZN(_049_)
  );
  AOI222_X1 _138_ (
    .A1(s_rx[3]),
    .A2(_044_),
    .B1(_048_),
    .B2(r_ctrl[3]),
    .C1(_049_),
    .C2(r_cmd[3]),
    .ZN(_050_)
  );
  NAND2_X1 _139_ (
    .A1(_047_),
    .A2(_050_),
    .ZN(PRDATA[3])
  );
  AOI22_X1 _140_ (
    .A1(r_tx[0]),
    .A2(_046_),
    .B1(_048_),
    .B2(r_ctrl[0]),
    .ZN(_051_)
  );
  AOI22_X1 _141_ (
    .A1(r_pre[0]),
    .A2(_045_),
    .B1(_049_),
    .B2(r_cmd[0]),
    .ZN(_052_)
  );
  NOR4_X1 _142_ (
    .A1(PADDR[4]),
    .A2(PADDR[5]),
    .A3(_039_),
    .A4(_040_),
    .ZN(_053_)
  );
  AOI22_X1 _143_ (
    .A1(s_rx[0]),
    .A2(_044_),
    .B1(_053_),
    .B2(irq_flag),
    .ZN(_054_)
  );
  NAND3_X1 _144_ (
    .A1(_051_),
    .A2(_052_),
    .A3(_054_),
    .ZN(PRDATA[0])
  );
  AOI22_X1 _145_ (
    .A1(r_tx[7]),
    .A2(_046_),
    .B1(_048_),
    .B2(r_ctrl[7]),
    .ZN(_055_)
  );
  AOI22_X1 _146_ (
    .A1(r_pre[7]),
    .A2(_045_),
    .B1(_049_),
    .B2(r_cmd[7]),
    .ZN(_056_)
  );
  AOI22_X1 _147_ (
    .A1(s_rx[7]),
    .A2(_044_),
    .B1(_053_),
    .B2(rxack),
    .ZN(_057_)
  );
  NAND3_X1 _148_ (
    .A1(_055_),
    .A2(_056_),
    .A3(_057_),
    .ZN(PRDATA[7])
  );
  AOI22_X1 _149_ (
    .A1(r_ctrl[6]),
    .A2(_048_),
    .B1(_049_),
    .B2(r_cmd[6]),
    .ZN(_058_)
  );
  AOI22_X1 _150_ (
    .A1(r_pre[6]),
    .A2(_045_),
    .B1(_046_),
    .B2(r_tx[6]),
    .ZN(_059_)
  );
  AOI22_X1 _151_ (
    .A1(s_rx[6]),
    .A2(_044_),
    .B1(_053_),
    .B2(i2c_busy),
    .ZN(_060_)
  );
  NAND3_X1 _152_ (
    .A1(_058_),
    .A2(_059_),
    .A3(_060_),
    .ZN(PRDATA[6])
  );
  AND2_X1 _153_ (
    .A1(r_pre[8]),
    .A2(_045_),
    .ZN(PRDATA[8])
  );
  AND2_X1 _154_ (
    .A1(r_pre[12]),
    .A2(_045_),
    .ZN(PRDATA[12])
  );
  AND2_X1 _155_ (
    .A1(r_pre[11]),
    .A2(_045_),
    .ZN(PRDATA[11])
  );
  AND2_X1 _156_ (
    .A1(r_pre[13]),
    .A2(_045_),
    .ZN(PRDATA[13])
  );
  AND2_X1 _157_ (
    .A1(r_pre[9]),
    .A2(_045_),
    .ZN(PRDATA[9])
  );
  AND2_X1 _158_ (
    .A1(r_pre[10]),
    .A2(_045_),
    .ZN(PRDATA[10])
  );
  AND3_X1 _159_ (
    .A1(PWRITE),
    .A2(PSEL),
    .A3(PENABLE),
    .ZN(_061_)
  );
  AND3_X1 _160_ (
    .A1(r_ctrl[7]),
    .A2(_049_),
    .A3(_061_),
    .ZN(_062_)
  );
  AND2_X1 _161_ (
    .A1(PWDATA[1]),
    .A2(_062_),
    .ZN(_003_[1])
  );
  NOR2_X1 _162_ (
    .A1(s_done),
    .A2(i2c_al),
    .ZN(_063_)
  );
  AND2_X1 _163_ (
    .A1(r_cmd[6]),
    .A2(_063_),
    .ZN(_064_)
  );
  MUX2_X1 _164_ (
    .A(_064_),
    .B(PWDATA[6]),
    .S(_062_),
    .Z(_003_[6])
  );
  AND2_X1 _165_ (
    .A1(r_cmd[5]),
    .A2(_063_),
    .ZN(_065_)
  );
  MUX2_X1 _166_ (
    .A(_065_),
    .B(PWDATA[5]),
    .S(_062_),
    .Z(_003_[5])
  );
  AND2_X1 _167_ (
    .A1(r_cmd[4]),
    .A2(_063_),
    .ZN(_066_)
  );
  MUX2_X1 _168_ (
    .A(_066_),
    .B(PWDATA[4]),
    .S(_062_),
    .Z(_003_[4])
  );
  AND2_X1 _169_ (
    .A1(r_pre[14]),
    .A2(_045_),
    .ZN(PRDATA[14])
  );
  AND2_X1 _170_ (
    .A1(r_pre[15]),
    .A2(_045_),
    .ZN(PRDATA[15])
  );
  AOI22_X1 _171_ (
    .A1(r_tx[2]),
    .A2(_046_),
    .B1(_049_),
    .B2(r_cmd[2]),
    .ZN(_067_)
  );
  AOI222_X1 _172_ (
    .A1(s_rx[2]),
    .A2(_044_),
    .B1(_045_),
    .B2(r_pre[2]),
    .C1(_048_),
    .C2(r_ctrl[2]),
    .ZN(_068_)
  );
  NAND2_X1 _173_ (
    .A1(_067_),
    .A2(_068_),
    .ZN(PRDATA[2])
  );
  AOI22_X1 _174_ (
    .A1(r_tx[1]),
    .A2(_046_),
    .B1(_049_),
    .B2(r_cmd[1]),
    .ZN(_069_)
  );
  AOI22_X1 _175_ (
    .A1(r_pre[1]),
    .A2(_045_),
    .B1(_048_),
    .B2(r_ctrl[1]),
    .ZN(_070_)
  );
  AOI22_X1 _176_ (
    .A1(s_rx[1]),
    .A2(_044_),
    .B1(_053_),
    .B2(tip),
    .ZN(_071_)
  );
  NAND3_X1 _177_ (
    .A1(_069_),
    .A2(_070_),
    .A3(_071_),
    .ZN(PRDATA[1])
  );
  AOI22_X1 _178_ (
    .A1(r_ctrl[5]),
    .A2(_048_),
    .B1(_049_),
    .B2(r_cmd[5]),
    .ZN(_072_)
  );
  AOI22_X1 _179_ (
    .A1(r_pre[5]),
    .A2(_045_),
    .B1(_046_),
    .B2(r_tx[5]),
    .ZN(_073_)
  );
  AOI22_X1 _180_ (
    .A1(s_rx[5]),
    .A2(_044_),
    .B1(_053_),
    .B2(al),
    .ZN(_074_)
  );
  NAND3_X1 _181_ (
    .A1(_072_),
    .A2(_073_),
    .A3(_074_),
    .ZN(PRDATA[5])
  );
  AOI22_X1 _182_ (
    .A1(r_tx[4]),
    .A2(_046_),
    .B1(_049_),
    .B2(r_cmd[4]),
    .ZN(_075_)
  );
  AOI222_X1 _183_ (
    .A1(s_rx[4]),
    .A2(_044_),
    .B1(_045_),
    .B2(r_pre[4]),
    .C1(_048_),
    .C2(r_ctrl[4]),
    .ZN(_076_)
  );
  NAND2_X1 _184_ (
    .A1(_075_),
    .A2(_076_),
    .ZN(PRDATA[4])
  );
  AND2_X1 _185_ (
    .A1(PWDATA[0]),
    .A2(_062_),
    .ZN(_003_[0])
  );
  AND2_X1 _186_ (
    .A1(PWDATA[2]),
    .A2(_062_),
    .ZN(_003_[2])
  );
  AND2_X1 _187_ (
    .A1(r_cmd[7]),
    .A2(_063_),
    .ZN(_077_)
  );
  MUX2_X1 _188_ (
    .A(_077_),
    .B(PWDATA[7]),
    .S(_062_),
    .Z(_003_[7])
  );
  AND2_X1 _189_ (
    .A1(irq_flag),
    .A2(r_ctrl[6]),
    .ZN(_001_)
  );
  AOI21_X1 _190_ (
    .A(r_cmd[0]),
    .B1(_041_),
    .B2(_063_),
    .ZN(_002_)
  );
  OR2_X1 _191_ (
    .A1(r_cmd[5]),
    .A2(r_cmd[4]),
    .ZN(_004_)
  );
  OAI21_X1 _192_ (
    .A(_042_),
    .B1(_043_),
    .B2(r_cmd[7]),
    .ZN(_000_)
  );
  AND2_X1 _193_ (
    .A1(_045_),
    .A2(_061_),
    .ZN(_078_)
  );
  MUX2_X1 _194_ (
    .A(r_pre[2]),
    .B(PWDATA[2]),
    .S(_078_),
    .Z(_005_)
  );
  MUX2_X1 _195_ (
    .A(r_pre[1]),
    .B(PWDATA[1]),
    .S(_078_),
    .Z(_006_)
  );
  MUX2_X1 _196_ (
    .A(r_pre[0]),
    .B(PWDATA[0]),
    .S(_078_),
    .Z(_007_)
  );
  NAND2_X1 _197_ (
    .A1(_048_),
    .A2(_061_),
    .ZN(_079_)
  );
  MUX2_X1 _198_ (
    .A(PWDATA[5]),
    .B(r_ctrl[5]),
    .S(_079_),
    .Z(_008_)
  );
  MUX2_X1 _199_ (
    .A(PWDATA[4]),
    .B(r_ctrl[4]),
    .S(_079_),
    .Z(_009_)
  );
  MUX2_X1 _200_ (
    .A(PWDATA[3]),
    .B(r_ctrl[3]),
    .S(_079_),
    .Z(_010_)
  );
  MUX2_X1 _201_ (
    .A(PWDATA[2]),
    .B(r_ctrl[2]),
    .S(_079_),
    .Z(_011_)
  );
  MUX2_X1 _202_ (
    .A(PWDATA[1]),
    .B(r_ctrl[1]),
    .S(_079_),
    .Z(_012_)
  );
  MUX2_X1 _203_ (
    .A(PWDATA[0]),
    .B(r_ctrl[0]),
    .S(_079_),
    .Z(_013_)
  );
  MUX2_X1 _204_ (
    .A(PWDATA[6]),
    .B(r_ctrl[6]),
    .S(_079_),
    .Z(_014_)
  );
  MUX2_X1 _205_ (
    .A(r_pre[15]),
    .B(PWDATA[15]),
    .S(_078_),
    .Z(_015_)
  );
  NAND2_X1 _206_ (
    .A1(_046_),
    .A2(_061_),
    .ZN(_080_)
  );
  MUX2_X1 _207_ (
    .A(PWDATA[7]),
    .B(r_tx[7]),
    .S(_080_),
    .Z(_016_)
  );
  MUX2_X1 _208_ (
    .A(PWDATA[6]),
    .B(r_tx[6]),
    .S(_080_),
    .Z(_017_)
  );
  MUX2_X1 _209_ (
    .A(PWDATA[5]),
    .B(r_tx[5]),
    .S(_080_),
    .Z(_018_)
  );
  MUX2_X1 _210_ (
    .A(PWDATA[4]),
    .B(r_tx[4]),
    .S(_080_),
    .Z(_019_)
  );
  MUX2_X1 _211_ (
    .A(PWDATA[3]),
    .B(r_tx[3]),
    .S(_080_),
    .Z(_020_)
  );
  MUX2_X1 _212_ (
    .A(r_cmd[3]),
    .B(PWDATA[3]),
    .S(_062_),
    .Z(_021_)
  );
  MUX2_X1 _213_ (
    .A(PWDATA[2]),
    .B(r_tx[2]),
    .S(_080_),
    .Z(_022_)
  );
  MUX2_X1 _214_ (
    .A(PWDATA[1]),
    .B(r_tx[1]),
    .S(_080_),
    .Z(_023_)
  );
  MUX2_X1 _215_ (
    .A(PWDATA[0]),
    .B(r_tx[0]),
    .S(_080_),
    .Z(_024_)
  );
  MUX2_X1 _216_ (
    .A(r_pre[14]),
    .B(PWDATA[14]),
    .S(_078_),
    .Z(_025_)
  );
  MUX2_X1 _217_ (
    .A(r_pre[13]),
    .B(PWDATA[13]),
    .S(_078_),
    .Z(_026_)
  );
  MUX2_X1 _218_ (
    .A(r_pre[12]),
    .B(PWDATA[12]),
    .S(_078_),
    .Z(_027_)
  );
  MUX2_X1 _219_ (
    .A(r_pre[11]),
    .B(PWDATA[11]),
    .S(_078_),
    .Z(_028_)
  );
  MUX2_X1 _220_ (
    .A(r_pre[10]),
    .B(PWDATA[10]),
    .S(_078_),
    .Z(_029_)
  );
  MUX2_X1 _221_ (
    .A(r_pre[9]),
    .B(PWDATA[9]),
    .S(_078_),
    .Z(_030_)
  );
  MUX2_X1 _222_ (
    .A(r_pre[8]),
    .B(PWDATA[8]),
    .S(_078_),
    .Z(_031_)
  );
  MUX2_X1 _223_ (
    .A(r_pre[7]),
    .B(PWDATA[7]),
    .S(_078_),
    .Z(_032_)
  );
  MUX2_X1 _224_ (
    .A(PWDATA[7]),
    .B(r_ctrl[7]),
    .S(_079_),
    .Z(_033_)
  );
  MUX2_X1 _225_ (
    .A(r_pre[6]),
    .B(PWDATA[6]),
    .S(_078_),
    .Z(_034_)
  );
  MUX2_X1 _226_ (
    .A(r_pre[5]),
    .B(PWDATA[5]),
    .S(_078_),
    .Z(_035_)
  );
  MUX2_X1 _227_ (
    .A(r_pre[4]),
    .B(PWDATA[4]),
    .S(_078_),
    .Z(_036_)
  );
  MUX2_X1 _228_ (
    .A(r_pre[3]),
    .B(PWDATA[3]),
    .S(_078_),
    .Z(_037_)
  );
  DFFR_X1 _229_ (
    .CK(HCLK),
    .D(_007_),
    .Q(r_pre[0]),
    .QN(_111_),
    .RN(HRESETn)
  );
  DFFR_X1 _230_ (
    .CK(HCLK),
    .D(_006_),
    .Q(r_pre[1]),
    .QN(_112_),
    .RN(HRESETn)
  );
  DFFR_X1 _231_ (
    .CK(HCLK),
    .D(_005_),
    .Q(r_pre[2]),
    .QN(_113_),
    .RN(HRESETn)
  );
  DFFR_X1 _232_ (
    .CK(HCLK),
    .D(_037_),
    .Q(r_pre[3]),
    .QN(_125_),
    .RN(HRESETn)
  );
  DFFR_X1 _233_ (
    .CK(HCLK),
    .D(_036_),
    .Q(r_pre[4]),
    .QN(_082_),
    .RN(HRESETn)
  );
  DFFR_X1 _234_ (
    .CK(HCLK),
    .D(_035_),
    .Q(r_pre[5]),
    .QN(_083_),
    .RN(HRESETn)
  );
  DFFR_X1 _235_ (
    .CK(HCLK),
    .D(_034_),
    .Q(r_pre[6]),
    .QN(_084_),
    .RN(HRESETn)
  );
  DFFR_X1 _236_ (
    .CK(HCLK),
    .D(_032_),
    .Q(r_pre[7]),
    .QN(_086_),
    .RN(HRESETn)
  );
  DFFR_X1 _237_ (
    .CK(HCLK),
    .D(_031_),
    .Q(r_pre[8]),
    .QN(_087_),
    .RN(HRESETn)
  );
  DFFR_X1 _238_ (
    .CK(HCLK),
    .D(_030_),
    .Q(r_pre[9]),
    .QN(_088_),
    .RN(HRESETn)
  );
  DFFR_X1 _239_ (
    .CK(HCLK),
    .D(_029_),
    .Q(r_pre[10]),
    .QN(_089_),
    .RN(HRESETn)
  );
  DFFR_X1 _240_ (
    .CK(HCLK),
    .D(_028_),
    .Q(r_pre[11]),
    .QN(_090_),
    .RN(HRESETn)
  );
  DFFR_X1 _241_ (
    .CK(HCLK),
    .D(_027_),
    .Q(r_pre[12]),
    .QN(_091_),
    .RN(HRESETn)
  );
  DFFR_X1 _242_ (
    .CK(HCLK),
    .D(_026_),
    .Q(r_pre[13]),
    .QN(_092_),
    .RN(HRESETn)
  );
  DFFR_X1 _243_ (
    .CK(HCLK),
    .D(_025_),
    .Q(r_pre[14]),
    .QN(_093_),
    .RN(HRESETn)
  );
  DFFR_X1 _244_ (
    .CK(HCLK),
    .D(_015_),
    .Q(r_pre[15]),
    .QN(_118_),
    .RN(HRESETn)
  );
  DFFR_X1 _245_ (
    .CK(HCLK),
    .D(_024_),
    .Q(r_tx[0]),
    .QN(_124_),
    .RN(HRESETn)
  );
  DFFR_X1 _246_ (
    .CK(HCLK),
    .D(_023_),
    .Q(r_tx[1]),
    .QN(_095_),
    .RN(HRESETn)
  );
  DFFR_X1 _247_ (
    .CK(HCLK),
    .D(_022_),
    .Q(r_tx[2]),
    .QN(_096_),
    .RN(HRESETn)
  );
  DFFR_X1 _248_ (
    .CK(HCLK),
    .D(_020_),
    .Q(r_tx[3]),
    .QN(_098_),
    .RN(HRESETn)
  );
  DFFR_X1 _249_ (
    .CK(HCLK),
    .D(_019_),
    .Q(r_tx[4]),
    .QN(_099_),
    .RN(HRESETn)
  );
  DFFR_X1 _250_ (
    .CK(HCLK),
    .D(_018_),
    .Q(r_tx[5]),
    .QN(_122_),
    .RN(HRESETn)
  );
  DFFR_X1 _251_ (
    .CK(HCLK),
    .D(_017_),
    .Q(r_tx[6]),
    .QN(_101_),
    .RN(HRESETn)
  );
  DFFR_X1 _252_ (
    .CK(HCLK),
    .D(_016_),
    .Q(r_tx[7]),
    .QN(_121_),
    .RN(HRESETn)
  );
  DFFR_X1 _253_ (
    .CK(HCLK),
    .D(_003_[0]),
    .Q(r_cmd[0]),
    .QN(_102_),
    .RN(HRESETn)
  );
  DFFR_X1 _254_ (
    .CK(HCLK),
    .D(_003_[1]),
    .Q(r_cmd[1]),
    .QN(_103_),
    .RN(HRESETn)
  );
  DFFR_X1 _255_ (
    .CK(HCLK),
    .D(_003_[2]),
    .Q(r_cmd[2]),
    .QN(_120_),
    .RN(HRESETn)
  );
  DFFR_X1 _256_ (
    .CK(HCLK),
    .D(_003_[4]),
    .Q(r_cmd[4]),
    .QN(_119_),
    .RN(HRESETn)
  );
  DFFR_X1 _257_ (
    .CK(HCLK),
    .D(_003_[5]),
    .Q(r_cmd[5]),
    .QN(_104_),
    .RN(HRESETn)
  );
  DFFR_X1 _258_ (
    .CK(HCLK),
    .D(_003_[6]),
    .Q(r_cmd[6]),
    .QN(_117_),
    .RN(HRESETn)
  );
  DFFR_X1 _259_ (
    .CK(HCLK),
    .D(_003_[7]),
    .Q(r_cmd[7]),
    .QN(_110_),
    .RN(HRESETn)
  );
  DFFR_X1 _260_ (
    .CK(HCLK),
    .D(_021_),
    .Q(r_cmd[3]),
    .QN(_097_),
    .RN(HRESETn)
  );
  DFFR_X1 _261_ (
    .CK(HCLK),
    .D(_013_),
    .Q(r_ctrl[0]),
    .QN(_115_),
    .RN(HRESETn)
  );
  DFFR_X1 _262_ (
    .CK(HCLK),
    .D(_012_),
    .Q(r_ctrl[1]),
    .QN(_106_),
    .RN(HRESETn)
  );
  DFFR_X1 _263_ (
    .CK(HCLK),
    .D(_011_),
    .Q(r_ctrl[2]),
    .QN(_107_),
    .RN(HRESETn)
  );
  DFFR_X1 _264_ (
    .CK(HCLK),
    .D(_010_),
    .Q(r_ctrl[3]),
    .QN(_108_),
    .RN(HRESETn)
  );
  DFFR_X1 _265_ (
    .CK(HCLK),
    .D(_009_),
    .Q(r_ctrl[4]),
    .QN(_109_),
    .RN(HRESETn)
  );
  DFFR_X1 _266_ (
    .CK(HCLK),
    .D(_008_),
    .Q(r_ctrl[5]),
    .QN(_114_),
    .RN(HRESETn)
  );
  DFFR_X1 _267_ (
    .CK(HCLK),
    .D(_014_),
    .Q(r_ctrl[6]),
    .QN(_116_),
    .RN(HRESETn)
  );
  DFFR_X1 _268_ (
    .CK(HCLK),
    .D(_033_),
    .Q(r_ctrl[7]),
    .QN(_085_),
    .RN(HRESETn)
  );
  DFFR_X1 _269_ (
    .CK(HCLK),
    .D(_001_),
    .Q(interrupt_o),
    .QN(_123_),
    .RN(HRESETn)
  );
  DFFR_X1 _270_ (
    .CK(HCLK),
    .D(_000_),
    .Q(al),
    .QN(_105_),
    .RN(HRESETn)
  );
  DFFR_X1 _271_ (
    .CK(HCLK),
    .D(s_irxack),
    .Q(rxack),
    .QN(_081_),
    .RN(HRESETn)
  );
  DFFR_X1 _272_ (
    .CK(HCLK),
    .D(_004_),
    .Q(tip),
    .QN(_094_),
    .RN(HRESETn)
  );
  DFFR_X1 _273_ (
    .CK(HCLK),
    .D(_002_),
    .Q(irq_flag),
    .QN(_100_),
    .RN(HRESETn)
  );
  i2c_master_byte_ctrl byte_controller (
    .ack_in(r_cmd[3]),
    .ack_out(s_irxack),
    .clk(HCLK),
    .clk_cnt(r_pre),
    .cmd_ack(s_done),
    .din(r_tx),
    .dout(s_rx),
    .ena(r_ctrl[7]),
    .i2c_al(i2c_al),
    .i2c_busy(i2c_busy),
    .nReset(HRESETn),
    .read(r_cmd[5]),
    .scl_i(scl_pad_i),
    .scl_o(scl_pad_o),
    .scl_oen(scl_padoen_o),
    .sda_i(sda_pad_i),
    .sda_o(sda_pad_o),
    .sda_oen(sda_padoen_o),
    .start(r_cmd[7]),
    .stop(r_cmd[6]),
    .write(r_cmd[4])
  );
  assign iack = r_cmd[0];
  assign ack = r_cmd[3];
  assign wr = r_cmd[4];
  assign rd = r_cmd[5];
  assign sto = r_cmd[6];
  assign sta = r_cmd[7];
  assign s_ien = r_ctrl[6];
  assign s_core_en = r_ctrl[7];
  assign s_status = { rxack, i2c_busy, al, 3'h0, tip, irq_flag };
  assign s_apb_addr = PADDR[5:2];
  assign PSLVERR = 1'h0;
  assign PREADY = 1'h1;
  assign PRDATA[31:16] = 16'h0000;
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

module i2c_master_bit_ctrl(clk, nReset, ena, clk_cnt, cmd, cmd_ack, busy, al, din, dout, scl_i, scl_o, scl_oen, sda_i, sda_o, sda_oen);
  input clk;
  wire clk;
  input nReset;
  wire nReset;
  input ena;
  wire ena;
  input [15:0] clk_cnt;
  wire [15:0] clk_cnt;
  input [3:0] cmd;
  wire [3:0] cmd;
  output cmd_ack;
  wire cmd_ack;
  output busy;
  wire busy;
  output al;
  wire al;
  input din;
  wire din;
  output dout;
  wire dout;
  input scl_i;
  wire scl_i;
  output scl_o;
  wire scl_o;
  output scl_oen;
  wire scl_oen;
  input sda_i;
  wire sda_i;
  output sda_o;
  wire sda_o;
  output sda_oen;
  wire sda_oen;
  wire _000_;
  wire _001_;
  wire _002_;
  wire _003_;
  wire [13:0] _004_;
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
  wire [1:0] cSCL;
  wire [1:0] cSDA;
  wire [17:0] c_state;
  wire clk_en;
  wire cmd_stop;
  wire [15:0] cnt;
  wire dSCL;
  wire dSDA;
  wire dscl_oen;
  wire [2:0] fSCL;
  wire [2:0] fSDA;
  wire [13:0] filter_cnt;
  wire sSCL;
  wire sSDA;
  wire sda_chk;
  wire slave_wait;
  wire sta_condition;
  wire sto_condition;
  INV_X1 _380_ (
    .A(cnt[0]),
    .ZN(_056_)
  );
  INV_X1 _381_ (
    .A(filter_cnt[10]),
    .ZN(_057_)
  );
  INV_X1 _382_ (
    .A(filter_cnt[11]),
    .ZN(_058_)
  );
  INV_X1 _383_ (
    .A(clk_cnt[5]),
    .ZN(_059_)
  );
  INV_X1 _384_ (
    .A(ena),
    .ZN(_060_)
  );
  INV_X1 _385_ (
    .A(cmd[2]),
    .ZN(_061_)
  );
  INV_X1 _386_ (
    .A(cmd[1]),
    .ZN(_062_)
  );
  INV_X1 _387_ (
    .A(cnt[1]),
    .ZN(_063_)
  );
  INV_X1 _388_ (
    .A(cnt[2]),
    .ZN(_064_)
  );
  INV_X1 _389_ (
    .A(cnt[5]),
    .ZN(_065_)
  );
  INV_X1 _390_ (
    .A(cnt[9]),
    .ZN(_066_)
  );
  INV_X1 _391_ (
    .A(cnt[10]),
    .ZN(_067_)
  );
  INV_X1 _392_ (
    .A(cnt[11]),
    .ZN(_068_)
  );
  INV_X1 _393_ (
    .A(cnt[12]),
    .ZN(_069_)
  );
  INV_X1 _394_ (
    .A(cnt[13]),
    .ZN(_070_)
  );
  INV_X1 _395_ (
    .A(sSCL),
    .ZN(_071_)
  );
  INV_X1 _396_ (
    .A(cnt[15]),
    .ZN(_072_)
  );
  INV_X1 _397_ (
    .A(clk_cnt[3]),
    .ZN(_073_)
  );
  INV_X1 _398_ (
    .A(clk_cnt[11]),
    .ZN(_074_)
  );
  INV_X1 _399_ (
    .A(clk_cnt[10]),
    .ZN(_075_)
  );
  INV_X1 _400_ (
    .A(clk_cnt[12]),
    .ZN(_076_)
  );
  INV_X1 _401_ (
    .A(clk_cnt[4]),
    .ZN(_077_)
  );
  INV_X1 _402_ (
    .A(clk_cnt[9]),
    .ZN(_078_)
  );
  INV_X1 _403_ (
    .A(c_state[6]),
    .ZN(_079_)
  );
  INV_X1 _404_ (
    .A(c_state[7]),
    .ZN(_080_)
  );
  INV_X1 _405_ (
    .A(c_state[5]),
    .ZN(_081_)
  );
  INV_X1 _406_ (
    .A(c_state[4]),
    .ZN(_082_)
  );
  INV_X1 _407_ (
    .A(c_state[2]),
    .ZN(_083_)
  );
  INV_X1 _408_ (
    .A(c_state[3]),
    .ZN(_084_)
  );
  INV_X1 _409_ (
    .A(c_state[0]),
    .ZN(_085_)
  );
  INV_X1 _410_ (
    .A(c_state[1]),
    .ZN(_086_)
  );
  INV_X1 _411_ (
    .A(c_state[8]),
    .ZN(_087_)
  );
  INV_X1 _412_ (
    .A(c_state[11]),
    .ZN(_088_)
  );
  INV_X1 _413_ (
    .A(c_state[15]),
    .ZN(_089_)
  );
  INV_X1 _414_ (
    .A(c_state[13]),
    .ZN(_090_)
  );
  INV_X1 _415_ (
    .A(c_state[12]),
    .ZN(_091_)
  );
  INV_X1 _416_ (
    .A(c_state[16]),
    .ZN(_092_)
  );
  INV_X1 _417_ (
    .A(al),
    .ZN(_093_)
  );
  INV_X1 _418_ (
    .A(clk_cnt[7]),
    .ZN(_094_)
  );
  INV_X1 _419_ (
    .A(clk_cnt[8]),
    .ZN(_095_)
  );
  INV_X1 _420_ (
    .A(_010_),
    .ZN(_096_)
  );
  INV_X1 _421_ (
    .A(clk_en),
    .ZN(_097_)
  );
  INV_X1 _422_ (
    .A(din),
    .ZN(_098_)
  );
  INV_X1 _423_ (
    .A(clk_cnt[15]),
    .ZN(_099_)
  );
  INV_X1 _424_ (
    .A(sto_condition),
    .ZN(_100_)
  );
  INV_X1 _425_ (
    .A(sda_oen),
    .ZN(_101_)
  );
  INV_X1 _426_ (
    .A(sda_chk),
    .ZN(_102_)
  );
  INV_X1 _427_ (
    .A(dSDA),
    .ZN(_103_)
  );
  INV_X1 _428_ (
    .A(dscl_oen),
    .ZN(_104_)
  );
  OR2_X1 _429_ (
    .A1(filter_cnt[0]),
    .A2(filter_cnt[1]),
    .ZN(_105_)
  );
  OR4_X1 _430_ (
    .A1(filter_cnt[0]),
    .A2(filter_cnt[1]),
    .A3(filter_cnt[2]),
    .A4(filter_cnt[3]),
    .ZN(_106_)
  );
  OR2_X1 _431_ (
    .A1(filter_cnt[4]),
    .A2(_106_),
    .ZN(_107_)
  );
  NOR2_X1 _432_ (
    .A1(filter_cnt[5]),
    .A2(_107_),
    .ZN(_108_)
  );
  OR3_X1 _433_ (
    .A1(filter_cnt[5]),
    .A2(filter_cnt[6]),
    .A3(_107_),
    .ZN(_109_)
  );
  OR4_X1 _434_ (
    .A1(filter_cnt[5]),
    .A2(filter_cnt[6]),
    .A3(filter_cnt[7]),
    .A4(_107_),
    .ZN(_110_)
  );
  NOR3_X1 _435_ (
    .A1(filter_cnt[8]),
    .A2(filter_cnt[9]),
    .A3(_110_),
    .ZN(_111_)
  );
  INV_X1 _436_ (
    .A(_111_),
    .ZN(_112_)
  );
  NAND3_X1 _437_ (
    .A1(_057_),
    .A2(_058_),
    .A3(_111_),
    .ZN(_113_)
  );
  NOR3_X1 _438_ (
    .A1(filter_cnt[12]),
    .A2(filter_cnt[13]),
    .A3(_113_),
    .ZN(_114_)
  );
  OR3_X1 _439_ (
    .A1(filter_cnt[12]),
    .A2(filter_cnt[13]),
    .A3(_113_),
    .ZN(_115_)
  );
  OAI21_X1 _440_ (
    .A(filter_cnt[3]),
    .B1(_105_),
    .B2(filter_cnt[2]),
    .ZN(_116_)
  );
  AOI221_X1 _441_ (
    .A(_060_),
    .B1(_106_),
    .B2(_116_),
    .C1(_114_),
    .C2(_059_),
    .ZN(_004_[3])
  );
  NOR2_X1 _442_ (
    .A1(filter_cnt[13]),
    .A2(clk_cnt[14]),
    .ZN(_117_)
  );
  NOR3_X1 _443_ (
    .A1(filter_cnt[12]),
    .A2(_113_),
    .A3(_117_),
    .ZN(_118_)
  );
  AOI21_X1 _444_ (
    .A(_118_),
    .B1(_113_),
    .B2(filter_cnt[12]),
    .ZN(_119_)
  );
  NOR2_X1 _445_ (
    .A1(_060_),
    .A2(_119_),
    .ZN(_004_[12])
  );
  NOR2_X1 _446_ (
    .A1(cnt[0]),
    .A2(cnt[1]),
    .ZN(_120_)
  );
  NOR3_X1 _447_ (
    .A1(cnt[0]),
    .A2(cnt[1]),
    .A3(cnt[2]),
    .ZN(_121_)
  );
  OR4_X1 _448_ (
    .A1(cnt[0]),
    .A2(cnt[1]),
    .A3(cnt[2]),
    .A4(cnt[3]),
    .ZN(_122_)
  );
  OR3_X1 _449_ (
    .A1(cnt[4]),
    .A2(cnt[5]),
    .A3(_122_),
    .ZN(_123_)
  );
  OR3_X1 _450_ (
    .A1(cnt[6]),
    .A2(cnt[7]),
    .A3(cnt[8]),
    .ZN(_124_)
  );
  NOR4_X1 _451_ (
    .A1(cnt[4]),
    .A2(cnt[5]),
    .A3(_122_),
    .A4(_124_),
    .ZN(_125_)
  );
  NAND2_X1 _452_ (
    .A1(_066_),
    .A2(_125_),
    .ZN(_126_)
  );
  NAND4_X1 _453_ (
    .A1(_066_),
    .A2(_067_),
    .A3(_068_),
    .A4(_125_),
    .ZN(_127_)
  );
  OR2_X1 _454_ (
    .A1(cnt[12]),
    .A2(_127_),
    .ZN(_128_)
  );
  NOR4_X1 _455_ (
    .A1(cnt[12]),
    .A2(cnt[13]),
    .A3(cnt[14]),
    .A4(_127_),
    .ZN(_129_)
  );
  NAND2_X1 _456_ (
    .A1(dSCL),
    .A2(scl_oen),
    .ZN(_130_)
  );
  OAI21_X1 _457_ (
    .A(ena),
    .B1(sSCL),
    .B2(_130_),
    .ZN(_131_)
  );
  NOR2_X1 _458_ (
    .A1(_129_),
    .A2(_131_),
    .ZN(_132_)
  );
  AOI21_X1 _459_ (
    .A(_131_),
    .B1(_129_),
    .B2(_072_),
    .ZN(_133_)
  );
  INV_X1 _460_ (
    .A(_133_),
    .ZN(_002_)
  );
  OAI21_X1 _461_ (
    .A(filter_cnt[9]),
    .B1(_110_),
    .B2(filter_cnt[8]),
    .ZN(_134_)
  );
  AOI221_X1 _462_ (
    .A(_060_),
    .B1(_074_),
    .B2(_114_),
    .C1(_134_),
    .C2(_112_),
    .ZN(_004_[9])
  );
  XOR2_X1 _463_ (
    .A(filter_cnt[8]),
    .B(_110_),
    .Z(_135_)
  );
  AOI211_X1 _464_ (
    .A(_060_),
    .B(_135_),
    .C1(_114_),
    .C2(_075_),
    .ZN(_004_[8])
  );
  XNOR2_X1 _465_ (
    .A(filter_cnt[10]),
    .B(_111_),
    .ZN(_136_)
  );
  AOI211_X1 _466_ (
    .A(_060_),
    .B(_136_),
    .C1(_114_),
    .C2(_076_),
    .ZN(_004_[10])
  );
  XOR2_X1 _467_ (
    .A(filter_cnt[2]),
    .B(_105_),
    .Z(_137_)
  );
  AOI211_X1 _468_ (
    .A(_060_),
    .B(_137_),
    .C1(_114_),
    .C2(_077_),
    .ZN(_004_[2])
  );
  NAND2_X1 _469_ (
    .A1(filter_cnt[7]),
    .A2(_109_),
    .ZN(_138_)
  );
  AOI221_X1 _470_ (
    .A(_060_),
    .B1(_078_),
    .B2(_114_),
    .C1(_138_),
    .C2(_110_),
    .ZN(_004_[7])
  );
  XOR2_X1 _471_ (
    .A(filter_cnt[5]),
    .B(_107_),
    .Z(_139_)
  );
  AOI211_X1 _472_ (
    .A(_060_),
    .B(_139_),
    .C1(_114_),
    .C2(_094_),
    .ZN(_004_[5])
  );
  NAND2_X1 _473_ (
    .A1(filter_cnt[0]),
    .A2(filter_cnt[1]),
    .ZN(_140_)
  );
  AOI221_X1 _474_ (
    .A(_060_),
    .B1(_073_),
    .B2(_114_),
    .C1(_140_),
    .C2(_105_),
    .ZN(_004_[1])
  );
  NAND2_X1 _475_ (
    .A1(filter_cnt[4]),
    .A2(_106_),
    .ZN(_141_)
  );
  OAI21_X1 _476_ (
    .A(ena),
    .B1(clk_cnt[6]),
    .B2(_115_),
    .ZN(_142_)
  );
  AOI21_X1 _477_ (
    .A(_142_),
    .B1(_141_),
    .B2(_107_),
    .ZN(_004_[4])
  );
  OAI21_X1 _478_ (
    .A(ena),
    .B1(clk_cnt[2]),
    .B2(_115_),
    .ZN(_143_)
  );
  AOI21_X1 _479_ (
    .A(_143_),
    .B1(_115_),
    .B2(_096_),
    .ZN(_004_[0])
  );
  XNOR2_X1 _480_ (
    .A(filter_cnt[6]),
    .B(_108_),
    .ZN(_144_)
  );
  AOI211_X1 _481_ (
    .A(_060_),
    .B(_144_),
    .C1(_114_),
    .C2(_095_),
    .ZN(_004_[6])
  );
  OAI21_X1 _482_ (
    .A(filter_cnt[11]),
    .B1(_112_),
    .B2(filter_cnt[10]),
    .ZN(_145_)
  );
  OAI21_X1 _483_ (
    .A(ena),
    .B1(clk_cnt[13]),
    .B2(_115_),
    .ZN(_146_)
  );
  AOI21_X1 _484_ (
    .A(_146_),
    .B1(_145_),
    .B2(_113_),
    .ZN(_004_[11])
  );
  NOR2_X1 _485_ (
    .A1(c_state[2]),
    .A2(c_state[3]),
    .ZN(_147_)
  );
  NOR4_X1 _486_ (
    .A1(c_state[5]),
    .A2(c_state[4]),
    .A3(c_state[2]),
    .A4(c_state[3]),
    .ZN(_148_)
  );
  OR2_X1 _487_ (
    .A1(c_state[0]),
    .A2(c_state[1]),
    .ZN(_149_)
  );
  NOR4_X1 _488_ (
    .A1(c_state[6]),
    .A2(c_state[7]),
    .A3(c_state[0]),
    .A4(c_state[1]),
    .ZN(_150_)
  );
  OR3_X1 _489_ (
    .A1(c_state[6]),
    .A2(c_state[7]),
    .A3(_149_),
    .ZN(_151_)
  );
  NAND2_X1 _490_ (
    .A1(_148_),
    .A2(_150_),
    .ZN(_152_)
  );
  NOR2_X1 _491_ (
    .A1(c_state[13]),
    .A2(c_state[12]),
    .ZN(_153_)
  );
  NOR4_X1 _492_ (
    .A1(c_state[13]),
    .A2(c_state[12]),
    .A3(c_state[16]),
    .A4(c_state[14]),
    .ZN(_154_)
  );
  OR4_X1 _493_ (
    .A1(c_state[13]),
    .A2(c_state[12]),
    .A3(c_state[16]),
    .A4(c_state[14]),
    .ZN(_155_)
  );
  NAND3_X1 _494_ (
    .A1(_148_),
    .A2(_150_),
    .A3(_154_),
    .ZN(_156_)
  );
  AND4_X1 _495_ (
    .A1(_089_),
    .A2(_148_),
    .A3(_150_),
    .A4(_154_),
    .ZN(_157_)
  );
  NOR2_X1 _496_ (
    .A1(c_state[10]),
    .A2(c_state[11]),
    .ZN(_158_)
  );
  NOR2_X1 _497_ (
    .A1(c_state[9]),
    .A2(_087_),
    .ZN(_159_)
  );
  AND3_X1 _498_ (
    .A1(_157_),
    .A2(_158_),
    .A3(_159_),
    .ZN(_160_)
  );
  NOR2_X1 _499_ (
    .A1(c_state[9]),
    .A2(c_state[8]),
    .ZN(_161_)
  );
  NOR4_X1 _500_ (
    .A1(c_state[9]),
    .A2(c_state[8]),
    .A3(c_state[10]),
    .A4(c_state[11]),
    .ZN(_162_)
  );
  OR4_X1 _501_ (
    .A1(c_state[9]),
    .A2(c_state[8]),
    .A3(c_state[10]),
    .A4(c_state[11]),
    .ZN(_163_)
  );
  NAND4_X1 _502_ (
    .A1(_089_),
    .A2(_148_),
    .A3(_150_),
    .A4(_162_),
    .ZN(_164_)
  );
  OR3_X1 _503_ (
    .A1(c_state[16]),
    .A2(c_state[14]),
    .A3(_164_),
    .ZN(_165_)
  );
  NAND2_X1 _504_ (
    .A1(_090_),
    .A2(c_state[12]),
    .ZN(_166_)
  );
  NOR4_X1 _505_ (
    .A1(c_state[16]),
    .A2(c_state[14]),
    .A3(_164_),
    .A4(_166_),
    .ZN(_167_)
  );
  NAND2_X1 _506_ (
    .A1(c_state[16]),
    .A2(_153_),
    .ZN(_168_)
  );
  NOR3_X1 _507_ (
    .A1(c_state[14]),
    .A2(_164_),
    .A3(_168_),
    .ZN(_169_)
  );
  AND4_X1 _508_ (
    .A1(_089_),
    .A2(_147_),
    .A3(_154_),
    .A4(_162_),
    .ZN(_170_)
  );
  NAND4_X1 _509_ (
    .A1(_089_),
    .A2(_147_),
    .A3(_154_),
    .A4(_162_),
    .ZN(_171_)
  );
  NAND2_X1 _510_ (
    .A1(_150_),
    .A2(_170_),
    .ZN(_172_)
  );
  NAND2_X1 _511_ (
    .A1(_081_),
    .A2(c_state[4]),
    .ZN(_173_)
  );
  OAI33_X1 _512_ (
    .A1(c_state[14]),
    .A2(_164_),
    .A3(_168_),
    .B1(_171_),
    .B2(_173_),
    .B3(_151_),
    .ZN(_174_)
  );
  OR2_X1 _513_ (
    .A1(_167_),
    .A2(_174_),
    .ZN(_175_)
  );
  NOR2_X1 _514_ (
    .A1(_160_),
    .A2(_175_),
    .ZN(_176_)
  );
  NOR3_X1 _515_ (
    .A1(al),
    .A2(_097_),
    .A3(_176_),
    .ZN(_003_)
  );
  NAND2_X1 _516_ (
    .A1(clk_cnt[15]),
    .A2(_114_),
    .ZN(_177_)
  );
  OAI21_X1 _517_ (
    .A(filter_cnt[13]),
    .B1(_113_),
    .B2(filter_cnt[12]),
    .ZN(_178_)
  );
  AOI21_X1 _518_ (
    .A(_060_),
    .B1(_177_),
    .B2(_178_),
    .ZN(_004_[13])
  );
  NOR2_X1 _519_ (
    .A1(_155_),
    .A2(_164_),
    .ZN(_179_)
  );
  OAI33_X1 _520_ (
    .A1(_101_),
    .A2(_102_),
    .A3(sSDA),
    .B1(_179_),
    .B2(cmd_stop),
    .B3(_100_),
    .ZN(_000_)
  );
  NOR2_X1 _521_ (
    .A1(sta_condition),
    .A2(busy),
    .ZN(_180_)
  );
  NOR2_X1 _522_ (
    .A1(sto_condition),
    .A2(_180_),
    .ZN(_001_)
  );
  NAND2_X1 _523_ (
    .A1(sSCL),
    .A2(sSDA),
    .ZN(_181_)
  );
  NOR2_X1 _524_ (
    .A1(dSDA),
    .A2(_181_),
    .ZN(_009_)
  );
  NOR3_X1 _525_ (
    .A1(_071_),
    .A2(sSDA),
    .A3(_103_),
    .ZN(_008_)
  );
  NAND2_X1 _526_ (
    .A1(fSDA[2]),
    .A2(fSDA[0]),
    .ZN(_182_)
  );
  OAI21_X1 _527_ (
    .A(fSDA[1]),
    .B1(fSDA[0]),
    .B2(fSDA[2]),
    .ZN(_183_)
  );
  NAND2_X1 _528_ (
    .A1(_182_),
    .A2(_183_),
    .ZN(_006_)
  );
  NAND2_X1 _529_ (
    .A1(fSCL[2]),
    .A2(fSCL[0]),
    .ZN(_184_)
  );
  OAI21_X1 _530_ (
    .A(fSCL[1]),
    .B1(fSCL[0]),
    .B2(fSCL[2]),
    .ZN(_185_)
  );
  NAND2_X1 _531_ (
    .A1(_184_),
    .A2(_185_),
    .ZN(_005_)
  );
  AOI21_X1 _532_ (
    .A(slave_wait),
    .B1(_104_),
    .B2(scl_oen),
    .ZN(_186_)
  );
  NOR2_X1 _533_ (
    .A1(sSCL),
    .A2(_186_),
    .ZN(_007_)
  );
  NOR2_X1 _534_ (
    .A1(al),
    .A2(clk_en),
    .ZN(_187_)
  );
  NOR2_X1 _535_ (
    .A1(al),
    .A2(_179_),
    .ZN(_188_)
  );
  NOR4_X1 _536_ (
    .A1(c_state[6]),
    .A2(c_state[7]),
    .A3(c_state[5]),
    .A4(c_state[4]),
    .ZN(_189_)
  );
  NOR4_X1 _537_ (
    .A1(c_state[15]),
    .A2(_149_),
    .A3(_155_),
    .A4(_163_),
    .ZN(_190_)
  );
  NAND4_X1 _538_ (
    .A1(c_state[2]),
    .A2(_084_),
    .A3(_189_),
    .A4(_190_),
    .ZN(_191_)
  );
  NAND4_X1 _539_ (
    .A1(c_state[6]),
    .A2(_080_),
    .A3(_148_),
    .A4(_190_),
    .ZN(_192_)
  );
  NAND4_X1 _540_ (
    .A1(_083_),
    .A2(c_state[3]),
    .A3(_189_),
    .A4(_190_),
    .ZN(_193_)
  );
  NAND4_X1 _541_ (
    .A1(_079_),
    .A2(c_state[7]),
    .A3(_148_),
    .A4(_190_),
    .ZN(_194_)
  );
  NAND4_X1 _542_ (
    .A1(_191_),
    .A2(_192_),
    .A3(_193_),
    .A4(_194_),
    .ZN(_195_)
  );
  NAND2_X1 _543_ (
    .A1(c_state[15]),
    .A2(_162_),
    .ZN(_196_)
  );
  NAND3_X1 _544_ (
    .A1(_092_),
    .A2(c_state[14]),
    .A3(_153_),
    .ZN(_197_)
  );
  OAI22_X1 _545_ (
    .A1(_156_),
    .A2(_196_),
    .B1(_197_),
    .B2(_164_),
    .ZN(_198_)
  );
  NOR3_X1 _546_ (
    .A1(_081_),
    .A2(c_state[4]),
    .A3(_172_),
    .ZN(_199_)
  );
  NOR3_X1 _547_ (
    .A1(_195_),
    .A2(_198_),
    .A3(_199_),
    .ZN(_200_)
  );
  AND4_X1 _548_ (
    .A1(c_state[9]),
    .A2(_087_),
    .A3(_157_),
    .A4(_158_),
    .ZN(_201_)
  );
  NOR3_X1 _549_ (
    .A1(_090_),
    .A2(c_state[12]),
    .A3(_165_),
    .ZN(_202_)
  );
  NAND4_X1 _550_ (
    .A1(_085_),
    .A2(c_state[1]),
    .A3(_170_),
    .A4(_189_),
    .ZN(_203_)
  );
  NOR2_X1 _551_ (
    .A1(c_state[10]),
    .A2(_088_),
    .ZN(_204_)
  );
  NAND3_X1 _552_ (
    .A1(_157_),
    .A2(_161_),
    .A3(_204_),
    .ZN(_205_)
  );
  NAND4_X1 _553_ (
    .A1(c_state[10]),
    .A2(_088_),
    .A3(_157_),
    .A4(_161_),
    .ZN(_206_)
  );
  NAND3_X1 _554_ (
    .A1(_203_),
    .A2(_205_),
    .A3(_206_),
    .ZN(_207_)
  );
  NOR3_X1 _555_ (
    .A1(_090_),
    .A2(c_state[12]),
    .A3(_165_),
    .ZN(_208_)
  );
  NOR2_X1 _556_ (
    .A1(_201_),
    .A2(_208_),
    .ZN(_209_)
  );
  NAND4_X1 _557_ (
    .A1(c_state[0]),
    .A2(_086_),
    .A3(_170_),
    .A4(_189_),
    .ZN(_210_)
  );
  NAND4_X1 _558_ (
    .A1(_085_),
    .A2(c_state[1]),
    .A3(_170_),
    .A4(_189_),
    .ZN(_211_)
  );
  AND4_X1 _559_ (
    .A1(_205_),
    .A2(_206_),
    .A3(_210_),
    .A4(_211_),
    .ZN(_212_)
  );
  NOR3_X1 _560_ (
    .A1(c_state[13]),
    .A2(_091_),
    .A3(_165_),
    .ZN(_213_)
  );
  NOR3_X1 _561_ (
    .A1(c_state[5]),
    .A2(_082_),
    .A3(_172_),
    .ZN(_214_)
  );
  NOR4_X1 _562_ (
    .A1(_160_),
    .A2(_169_),
    .A3(_213_),
    .A4(_214_),
    .ZN(_215_)
  );
  NOR3_X1 _563_ (
    .A1(_081_),
    .A2(c_state[4]),
    .A3(_172_),
    .ZN(_216_)
  );
  NAND4_X1 _564_ (
    .A1(_083_),
    .A2(c_state[3]),
    .A3(_189_),
    .A4(_190_),
    .ZN(_217_)
  );
  NAND4_X1 _565_ (
    .A1(c_state[2]),
    .A2(_084_),
    .A3(_189_),
    .A4(_190_),
    .ZN(_218_)
  );
  NAND4_X1 _566_ (
    .A1(c_state[6]),
    .A2(_080_),
    .A3(_148_),
    .A4(_190_),
    .ZN(_219_)
  );
  NAND4_X1 _567_ (
    .A1(_079_),
    .A2(c_state[7]),
    .A3(_148_),
    .A4(_190_),
    .ZN(_220_)
  );
  NAND4_X1 _568_ (
    .A1(_217_),
    .A2(_218_),
    .A3(_219_),
    .A4(_220_),
    .ZN(_221_)
  );
  NOR4_X1 _569_ (
    .A1(_089_),
    .A2(_152_),
    .A3(_155_),
    .A4(_163_),
    .ZN(_222_)
  );
  NOR4_X1 _570_ (
    .A1(c_state[15]),
    .A2(_152_),
    .A3(_163_),
    .A4(_197_),
    .ZN(_223_)
  );
  NOR4_X1 _571_ (
    .A1(_216_),
    .A2(_221_),
    .A3(_222_),
    .A4(_223_),
    .ZN(_224_)
  );
  AND4_X1 _572_ (
    .A1(_209_),
    .A2(_212_),
    .A3(_215_),
    .A4(_224_),
    .ZN(_225_)
  );
  NAND4_X1 _573_ (
    .A1(_209_),
    .A2(_212_),
    .A3(_215_),
    .A4(_224_),
    .ZN(_226_)
  );
  AOI21_X1 _574_ (
    .A(_187_),
    .B1(_188_),
    .B2(_225_),
    .ZN(_227_)
  );
  NOR2_X1 _575_ (
    .A1(al),
    .A2(_205_),
    .ZN(_228_)
  );
  MUX2_X1 _576_ (
    .A(c_state[12]),
    .B(_228_),
    .S(_227_),
    .Z(_012_)
  );
  NOR2_X1 _577_ (
    .A1(al),
    .A2(_206_),
    .ZN(_229_)
  );
  MUX2_X1 _578_ (
    .A(c_state[11]),
    .B(_229_),
    .S(_227_),
    .Z(_013_)
  );
  AND2_X1 _579_ (
    .A1(_093_),
    .A2(_201_),
    .ZN(_230_)
  );
  MUX2_X1 _580_ (
    .A(c_state[10]),
    .B(_230_),
    .S(_227_),
    .Z(_014_)
  );
  NAND3_X1 _581_ (
    .A1(_061_),
    .A2(cmd[3]),
    .A3(_093_),
    .ZN(_231_)
  );
  NOR4_X1 _582_ (
    .A1(cmd[1]),
    .A2(cmd[0]),
    .A3(_226_),
    .A4(_231_),
    .ZN(_232_)
  );
  MUX2_X1 _583_ (
    .A(c_state[9]),
    .B(_232_),
    .S(_227_),
    .Z(_015_)
  );
  NOR2_X1 _584_ (
    .A1(al),
    .A2(_220_),
    .ZN(_233_)
  );
  MUX2_X1 _585_ (
    .A(c_state[8]),
    .B(_233_),
    .S(_227_),
    .Z(_016_)
  );
  NOR2_X1 _586_ (
    .A1(al),
    .A2(_219_),
    .ZN(_234_)
  );
  MUX2_X1 _587_ (
    .A(c_state[7]),
    .B(_234_),
    .S(_227_),
    .Z(_017_)
  );
  AND2_X1 _588_ (
    .A1(_093_),
    .A2(_216_),
    .ZN(_235_)
  );
  MUX2_X1 _589_ (
    .A(c_state[6]),
    .B(_235_),
    .S(_227_),
    .Z(_018_)
  );
  OR4_X1 _590_ (
    .A1(cmd[2]),
    .A2(cmd[3]),
    .A3(_062_),
    .A4(cmd[0]),
    .ZN(_236_)
  );
  NOR3_X1 _591_ (
    .A1(al),
    .A2(_226_),
    .A3(_236_),
    .ZN(_237_)
  );
  MUX2_X1 _592_ (
    .A(c_state[5]),
    .B(_237_),
    .S(_227_),
    .Z(_019_)
  );
  NOR2_X1 _593_ (
    .A1(al),
    .A2(_217_),
    .ZN(_238_)
  );
  MUX2_X1 _594_ (
    .A(c_state[4]),
    .B(_238_),
    .S(_227_),
    .Z(_020_)
  );
  NOR2_X1 _595_ (
    .A1(al),
    .A2(_218_),
    .ZN(_239_)
  );
  MUX2_X1 _596_ (
    .A(c_state[3]),
    .B(_239_),
    .S(_227_),
    .Z(_021_)
  );
  NOR2_X1 _597_ (
    .A1(al),
    .A2(_211_),
    .ZN(_240_)
  );
  MUX2_X1 _598_ (
    .A(c_state[2]),
    .B(_240_),
    .S(_227_),
    .Z(_022_)
  );
  NOR2_X1 _599_ (
    .A1(al),
    .A2(_210_),
    .ZN(_241_)
  );
  MUX2_X1 _600_ (
    .A(c_state[1]),
    .B(_241_),
    .S(_227_),
    .Z(_023_)
  );
  NAND3_X1 _601_ (
    .A1(_062_),
    .A2(cmd[0]),
    .A3(_093_),
    .ZN(_242_)
  );
  NOR4_X1 _602_ (
    .A1(cmd[2]),
    .A2(cmd[3]),
    .A3(_226_),
    .A4(_242_),
    .ZN(_243_)
  );
  MUX2_X1 _603_ (
    .A(c_state[0]),
    .B(_243_),
    .S(_227_),
    .Z(_024_)
  );
  NOR3_X1 _604_ (
    .A1(al),
    .A2(_156_),
    .A3(_196_),
    .ZN(_244_)
  );
  MUX2_X1 _605_ (
    .A(c_state[16]),
    .B(_244_),
    .S(_227_),
    .Z(_025_)
  );
  AND2_X1 _606_ (
    .A1(slave_wait),
    .A2(_133_),
    .ZN(_245_)
  );
  NAND2_X1 _607_ (
    .A1(slave_wait),
    .A2(_133_),
    .ZN(_246_)
  );
  AOI21_X1 _608_ (
    .A(_132_),
    .B1(_133_),
    .B2(slave_wait),
    .ZN(_247_)
  );
  NOR2_X1 _609_ (
    .A1(cnt[14]),
    .A2(_247_),
    .ZN(_248_)
  );
  NOR2_X1 _610_ (
    .A1(clk_cnt[14]),
    .A2(_133_),
    .ZN(_249_)
  );
  NOR3_X1 _611_ (
    .A1(cnt[13]),
    .A2(slave_wait),
    .A3(_128_),
    .ZN(_250_)
  );
  AOI211_X1 _612_ (
    .A(_248_),
    .B(_249_),
    .C1(_250_),
    .C2(_132_),
    .ZN(_026_)
  );
  XNOR2_X1 _613_ (
    .A(_070_),
    .B(_128_),
    .ZN(_251_)
  );
  OAI21_X1 _614_ (
    .A(_133_),
    .B1(_251_),
    .B2(slave_wait),
    .ZN(_252_)
  );
  OAI21_X1 _615_ (
    .A(_252_),
    .B1(_133_),
    .B2(clk_cnt[13]),
    .ZN(_253_)
  );
  OAI21_X1 _616_ (
    .A(_253_),
    .B1(_246_),
    .B2(_070_),
    .ZN(_027_)
  );
  XNOR2_X1 _617_ (
    .A(_069_),
    .B(_127_),
    .ZN(_254_)
  );
  OAI21_X1 _618_ (
    .A(_133_),
    .B1(_254_),
    .B2(slave_wait),
    .ZN(_255_)
  );
  OAI21_X1 _619_ (
    .A(_255_),
    .B1(_133_),
    .B2(clk_cnt[12]),
    .ZN(_256_)
  );
  OAI21_X1 _620_ (
    .A(_256_),
    .B1(_246_),
    .B2(_069_),
    .ZN(_028_)
  );
  OAI21_X1 _621_ (
    .A(cnt[11]),
    .B1(_126_),
    .B2(cnt[10]),
    .ZN(_257_)
  );
  AND2_X1 _622_ (
    .A1(_127_),
    .A2(_257_),
    .ZN(_258_)
  );
  OAI21_X1 _623_ (
    .A(_133_),
    .B1(_258_),
    .B2(slave_wait),
    .ZN(_259_)
  );
  OAI21_X1 _624_ (
    .A(_259_),
    .B1(_133_),
    .B2(clk_cnt[11]),
    .ZN(_260_)
  );
  OAI21_X1 _625_ (
    .A(_260_),
    .B1(_246_),
    .B2(_068_),
    .ZN(_029_)
  );
  XNOR2_X1 _626_ (
    .A(_067_),
    .B(_126_),
    .ZN(_261_)
  );
  OAI21_X1 _627_ (
    .A(_133_),
    .B1(_261_),
    .B2(slave_wait),
    .ZN(_262_)
  );
  OAI21_X1 _628_ (
    .A(_262_),
    .B1(_133_),
    .B2(clk_cnt[10]),
    .ZN(_263_)
  );
  OAI21_X1 _629_ (
    .A(_263_),
    .B1(_246_),
    .B2(_067_),
    .ZN(_030_)
  );
  XNOR2_X1 _630_ (
    .A(cnt[9]),
    .B(_125_),
    .ZN(_264_)
  );
  OR3_X1 _631_ (
    .A1(slave_wait),
    .A2(_002_),
    .A3(_264_),
    .ZN(_265_)
  );
  OAI221_X1 _632_ (
    .A(_265_),
    .B1(_133_),
    .B2(_078_),
    .C1(_066_),
    .C2(_246_),
    .ZN(_031_)
  );
  OR3_X1 _633_ (
    .A1(cnt[6]),
    .A2(slave_wait),
    .A3(_123_),
    .ZN(_266_)
  );
  NOR2_X1 _634_ (
    .A1(cnt[7]),
    .A2(_266_),
    .ZN(_267_)
  );
  XOR2_X1 _635_ (
    .A(cnt[8]),
    .B(_267_),
    .Z(_268_)
  );
  MUX2_X1 _636_ (
    .A(clk_cnt[8]),
    .B(_268_),
    .S(_133_),
    .Z(_032_)
  );
  MUX2_X1 _637_ (
    .A(sda_chk),
    .B(_244_),
    .S(_227_),
    .Z(_033_)
  );
  XNOR2_X1 _638_ (
    .A(cnt[7]),
    .B(_266_),
    .ZN(_269_)
  );
  MUX2_X1 _639_ (
    .A(clk_cnt[7]),
    .B(_269_),
    .S(_133_),
    .Z(_034_)
  );
  OAI21_X1 _640_ (
    .A(cnt[6]),
    .B1(slave_wait),
    .B2(_123_),
    .ZN(_270_)
  );
  NAND2_X1 _641_ (
    .A1(_266_),
    .A2(_270_),
    .ZN(_271_)
  );
  MUX2_X1 _642_ (
    .A(clk_cnt[6]),
    .B(_271_),
    .S(_133_),
    .Z(_035_)
  );
  OAI21_X1 _643_ (
    .A(cnt[5]),
    .B1(_122_),
    .B2(cnt[4]),
    .ZN(_272_)
  );
  AOI21_X1 _644_ (
    .A(slave_wait),
    .B1(_123_),
    .B2(_272_),
    .ZN(_273_)
  );
  NAND2_X1 _645_ (
    .A1(_133_),
    .A2(_273_),
    .ZN(_274_)
  );
  OAI221_X1 _646_ (
    .A(_274_),
    .B1(_246_),
    .B2(_065_),
    .C1(_059_),
    .C2(_133_),
    .ZN(_036_)
  );
  NOR2_X1 _647_ (
    .A1(slave_wait),
    .A2(_122_),
    .ZN(_275_)
  );
  XOR2_X1 _648_ (
    .A(cnt[4]),
    .B(_275_),
    .Z(_276_)
  );
  MUX2_X1 _649_ (
    .A(clk_cnt[4]),
    .B(_276_),
    .S(_133_),
    .Z(_037_)
  );
  NAND2_X1 _650_ (
    .A1(cnt[3]),
    .A2(_245_),
    .ZN(_277_)
  );
  XOR2_X1 _651_ (
    .A(cnt[3]),
    .B(_121_),
    .Z(_278_)
  );
  NAND2_X1 _652_ (
    .A1(_133_),
    .A2(_278_),
    .ZN(_279_)
  );
  OAI221_X1 _653_ (
    .A(_277_),
    .B1(_279_),
    .B2(slave_wait),
    .C1(_133_),
    .C2(_073_),
    .ZN(_038_)
  );
  XNOR2_X1 _654_ (
    .A(cnt[2]),
    .B(_120_),
    .ZN(_280_)
  );
  OAI21_X1 _655_ (
    .A(_133_),
    .B1(_280_),
    .B2(slave_wait),
    .ZN(_281_)
  );
  OAI21_X1 _656_ (
    .A(_281_),
    .B1(_133_),
    .B2(clk_cnt[2]),
    .ZN(_282_)
  );
  OAI21_X1 _657_ (
    .A(_282_),
    .B1(_246_),
    .B2(_064_),
    .ZN(_039_)
  );
  XOR2_X1 _658_ (
    .A(cnt[0]),
    .B(cnt[1]),
    .Z(_283_)
  );
  OAI21_X1 _659_ (
    .A(_133_),
    .B1(_283_),
    .B2(slave_wait),
    .ZN(_284_)
  );
  OAI21_X1 _660_ (
    .A(_284_),
    .B1(_133_),
    .B2(clk_cnt[1]),
    .ZN(_285_)
  );
  OAI21_X1 _661_ (
    .A(_285_),
    .B1(_246_),
    .B2(_063_),
    .ZN(_040_)
  );
  NAND2_X1 _662_ (
    .A1(clk_cnt[0]),
    .A2(_002_),
    .ZN(_286_)
  );
  OAI21_X1 _663_ (
    .A(_133_),
    .B1(slave_wait),
    .B2(_011_),
    .ZN(_287_)
  );
  AOI22_X1 _664_ (
    .A1(_056_),
    .A2(_245_),
    .B1(_286_),
    .B2(_287_),
    .ZN(_041_)
  );
  MUX2_X1 _665_ (
    .A(fSCL[0]),
    .B(cSCL[1]),
    .S(_114_),
    .Z(_042_)
  );
  MUX2_X1 _666_ (
    .A(fSDA[1]),
    .B(fSDA[0]),
    .S(_114_),
    .Z(_043_)
  );
  MUX2_X1 _667_ (
    .A(fSDA[0]),
    .B(cSDA[1]),
    .S(_114_),
    .Z(_044_)
  );
  OAI21_X1 _668_ (
    .A(dout),
    .B1(_071_),
    .B2(dSCL),
    .ZN(_288_)
  );
  OAI21_X1 _669_ (
    .A(_288_),
    .B1(_181_),
    .B2(dSCL),
    .ZN(_045_)
  );
  MUX2_X1 _670_ (
    .A(fSCL[2]),
    .B(fSCL[1]),
    .S(_114_),
    .Z(_046_)
  );
  MUX2_X1 _671_ (
    .A(fSCL[1]),
    .B(fSCL[0]),
    .S(_114_),
    .Z(_047_)
  );
  NOR3_X1 _672_ (
    .A1(al),
    .A2(_164_),
    .A3(_197_),
    .ZN(_289_)
  );
  MUX2_X1 _673_ (
    .A(c_state[15]),
    .B(_289_),
    .S(_227_),
    .Z(_048_)
  );
  AND2_X1 _674_ (
    .A1(_093_),
    .A2(_208_),
    .ZN(_290_)
  );
  MUX2_X1 _675_ (
    .A(c_state[14]),
    .B(_290_),
    .S(_227_),
    .Z(_049_)
  );
  NAND2_X1 _676_ (
    .A1(_097_),
    .A2(cmd_stop),
    .ZN(_291_)
  );
  OAI21_X1 _677_ (
    .A(_291_),
    .B1(_236_),
    .B2(_097_),
    .ZN(_050_)
  );
  OR3_X1 _678_ (
    .A1(_061_),
    .A2(cmd[3]),
    .A3(al),
    .ZN(_292_)
  );
  NOR4_X1 _679_ (
    .A1(cmd[1]),
    .A2(cmd[0]),
    .A3(_226_),
    .A4(_292_),
    .ZN(_293_)
  );
  MUX2_X1 _680_ (
    .A(c_state[13]),
    .B(_293_),
    .S(_227_),
    .Z(_051_)
  );
  NOR4_X1 _681_ (
    .A1(al),
    .A2(_160_),
    .A3(_167_),
    .A4(_201_),
    .ZN(_294_)
  );
  AND2_X1 _682_ (
    .A1(_212_),
    .A2(_294_),
    .ZN(_295_)
  );
  NOR2_X1 _683_ (
    .A1(_174_),
    .A2(_202_),
    .ZN(_296_)
  );
  NOR3_X1 _684_ (
    .A1(_169_),
    .A2(_198_),
    .A3(_208_),
    .ZN(_297_)
  );
  NAND3_X1 _685_ (
    .A1(_200_),
    .A2(_295_),
    .A3(_296_),
    .ZN(_298_)
  );
  OAI21_X1 _686_ (
    .A(_298_),
    .B1(clk_en),
    .B2(al),
    .ZN(_299_)
  );
  OAI21_X1 _687_ (
    .A(_295_),
    .B1(_297_),
    .B2(_098_),
    .ZN(_300_)
  );
  MUX2_X1 _688_ (
    .A(_300_),
    .B(sda_oen),
    .S(_299_),
    .Z(_052_)
  );
  MUX2_X1 _689_ (
    .A(fSDA[2]),
    .B(fSDA[1]),
    .S(_114_),
    .Z(_053_)
  );
  NOR4_X1 _690_ (
    .A1(_175_),
    .A2(_199_),
    .A3(_201_),
    .A4(_202_),
    .ZN(_301_)
  );
  OR3_X1 _691_ (
    .A1(al),
    .A2(_160_),
    .A3(_198_),
    .ZN(_302_)
  );
  NOR3_X1 _692_ (
    .A1(_195_),
    .A2(_207_),
    .A3(_302_),
    .ZN(_303_)
  );
  AOI21_X1 _693_ (
    .A(_187_),
    .B1(_301_),
    .B2(_303_),
    .ZN(_304_)
  );
  NOR2_X1 _694_ (
    .A1(scl_oen),
    .A2(_304_),
    .ZN(_305_)
  );
  NOR3_X1 _695_ (
    .A1(al),
    .A2(_097_),
    .A3(_301_),
    .ZN(_306_)
  );
  NOR2_X1 _696_ (
    .A1(_305_),
    .A2(_306_),
    .ZN(_054_)
  );
  OAI21_X1 _697_ (
    .A(cnt[15]),
    .B1(_132_),
    .B2(_245_),
    .ZN(_307_)
  );
  OAI21_X1 _698_ (
    .A(_307_),
    .B1(_133_),
    .B2(_099_),
    .ZN(_055_)
  );
  DFFR_X1 _699_ (
    .CK(clk),
    .D(_024_),
    .Q(c_state[0]),
    .QN(_338_),
    .RN(nReset)
  );
  DFFR_X1 _700_ (
    .CK(clk),
    .D(_023_),
    .Q(c_state[1]),
    .QN(_339_),
    .RN(nReset)
  );
  DFFR_X1 _701_ (
    .CK(clk),
    .D(_022_),
    .Q(c_state[2]),
    .QN(_340_),
    .RN(nReset)
  );
  DFFR_X1 _702_ (
    .CK(clk),
    .D(_021_),
    .Q(c_state[3]),
    .QN(_351_),
    .RN(nReset)
  );
  DFFR_X1 _703_ (
    .CK(clk),
    .D(_020_),
    .Q(c_state[4]),
    .QN(_342_),
    .RN(nReset)
  );
  DFFR_X1 _704_ (
    .CK(clk),
    .D(_019_),
    .Q(c_state[5]),
    .QN(_343_),
    .RN(nReset)
  );
  DFFR_X1 _705_ (
    .CK(clk),
    .D(_018_),
    .Q(c_state[6]),
    .QN(_344_),
    .RN(nReset)
  );
  DFFR_X1 _706_ (
    .CK(clk),
    .D(_017_),
    .Q(c_state[7]),
    .QN(_345_),
    .RN(nReset)
  );
  DFFR_X1 _707_ (
    .CK(clk),
    .D(_016_),
    .Q(c_state[8]),
    .QN(_346_),
    .RN(nReset)
  );
  DFFR_X1 _708_ (
    .CK(clk),
    .D(_015_),
    .Q(c_state[9]),
    .QN(_347_),
    .RN(nReset)
  );
  DFFR_X1 _709_ (
    .CK(clk),
    .D(_014_),
    .Q(c_state[10]),
    .QN(_348_),
    .RN(nReset)
  );
  DFFR_X1 _710_ (
    .CK(clk),
    .D(_013_),
    .Q(c_state[11]),
    .QN(_349_),
    .RN(nReset)
  );
  DFFR_X1 _711_ (
    .CK(clk),
    .D(_012_),
    .Q(c_state[12]),
    .QN(_350_),
    .RN(nReset)
  );
  DFFR_X1 _712_ (
    .CK(clk),
    .D(_051_),
    .Q(c_state[13]),
    .QN(_312_),
    .RN(nReset)
  );
  DFFR_X1 _713_ (
    .CK(clk),
    .D(_049_),
    .Q(c_state[14]),
    .QN(_314_),
    .RN(nReset)
  );
  DFFR_X1 _714_ (
    .CK(clk),
    .D(_048_),
    .Q(c_state[15]),
    .QN(_315_),
    .RN(nReset)
  );
  DFFR_X1 _715_ (
    .CK(clk),
    .D(_025_),
    .Q(c_state[16]),
    .QN(_337_),
    .RN(nReset)
  );
  DFFS_X1 _716_ (
    .CK(clk),
    .D(_052_),
    .Q(sda_oen),
    .QN(_311_),
    .SN(nReset)
  );
  DFFS_X1 _717_ (
    .CK(clk),
    .D(_044_),
    .Q(fSDA[0]),
    .QN(_357_),
    .SN(nReset)
  );
  DFFS_X1 _718_ (
    .CK(clk),
    .D(_043_),
    .Q(fSDA[1]),
    .QN(_320_),
    .SN(nReset)
  );
  DFFS_X1 _719_ (
    .CK(clk),
    .D(_053_),
    .Q(fSDA[2]),
    .QN(_374_),
    .SN(nReset)
  );
  DFFS_X1 _720_ (
    .CK(clk),
    .D(_054_),
    .Q(scl_oen),
    .QN(_375_),
    .SN(nReset)
  );
  DFFR_X1 _721_ (
    .CK(clk),
    .D(_041_),
    .Q(cnt[0]),
    .QN(_011_),
    .RN(nReset)
  );
  DFFR_X1 _722_ (
    .CK(clk),
    .D(_040_),
    .Q(cnt[1]),
    .QN(_322_),
    .RN(nReset)
  );
  DFFR_X1 _723_ (
    .CK(clk),
    .D(_039_),
    .Q(cnt[2]),
    .QN(_323_),
    .RN(nReset)
  );
  DFFR_X1 _724_ (
    .CK(clk),
    .D(_038_),
    .Q(cnt[3]),
    .QN(_324_),
    .RN(nReset)
  );
  DFFR_X1 _725_ (
    .CK(clk),
    .D(_037_),
    .Q(cnt[4]),
    .QN(_325_),
    .RN(nReset)
  );
  DFFR_X1 _726_ (
    .CK(clk),
    .D(_036_),
    .Q(cnt[5]),
    .QN(_353_),
    .RN(nReset)
  );
  DFFR_X1 _727_ (
    .CK(clk),
    .D(_035_),
    .Q(cnt[6]),
    .QN(_327_),
    .RN(nReset)
  );
  DFFR_X1 _728_ (
    .CK(clk),
    .D(_034_),
    .Q(cnt[7]),
    .QN(_328_),
    .RN(nReset)
  );
  DFFR_X1 _729_ (
    .CK(clk),
    .D(_032_),
    .Q(cnt[8]),
    .QN(_330_),
    .RN(nReset)
  );
  DFFR_X1 _730_ (
    .CK(clk),
    .D(_031_),
    .Q(cnt[9]),
    .QN(_352_),
    .RN(nReset)
  );
  DFFR_X1 _731_ (
    .CK(clk),
    .D(_030_),
    .Q(cnt[10]),
    .QN(_332_),
    .RN(nReset)
  );
  DFFR_X1 _732_ (
    .CK(clk),
    .D(_029_),
    .Q(cnt[11]),
    .QN(_333_),
    .RN(nReset)
  );
  DFFR_X1 _733_ (
    .CK(clk),
    .D(_028_),
    .Q(cnt[12]),
    .QN(_334_),
    .RN(nReset)
  );
  DFFR_X1 _734_ (
    .CK(clk),
    .D(_027_),
    .Q(cnt[13]),
    .QN(_335_),
    .RN(nReset)
  );
  DFFR_X1 _735_ (
    .CK(clk),
    .D(_026_),
    .Q(cnt[14]),
    .QN(_336_),
    .RN(nReset)
  );
  DFFR_X1 _736_ (
    .CK(clk),
    .D(_055_),
    .Q(cnt[15]),
    .QN(_379_),
    .RN(nReset)
  );
  DFFR_X1 _737_ (
    .CK(clk),
    .D(_033_),
    .Q(sda_chk),
    .QN(_329_),
    .RN(nReset)
  );
  DFF_X1 _738_ (
    .CK(clk),
    .D(_045_),
    .Q(dout),
    .QN(_364_)
  );
  DFFS_X1 _739_ (
    .CK(clk),
    .D(_042_),
    .Q(fSCL[0]),
    .QN(_354_),
    .SN(nReset)
  );
  DFFS_X1 _740_ (
    .CK(clk),
    .D(_047_),
    .Q(fSCL[1]),
    .QN(_373_),
    .SN(nReset)
  );
  DFFS_X1 _741_ (
    .CK(clk),
    .D(_046_),
    .Q(fSCL[2]),
    .QN(_366_),
    .SN(nReset)
  );
  DFFR_X1 _742_ (
    .CK(clk),
    .D(_050_),
    .Q(cmd_stop),
    .QN(_313_),
    .RN(nReset)
  );
  DFFR_X1 _743_ (
    .CK(clk),
    .D(_003_),
    .Q(cmd_ack),
    .QN(_378_),
    .RN(nReset)
  );
  DFFR_X1 _744_ (
    .CK(clk),
    .D(_000_),
    .Q(al),
    .QN(_369_),
    .RN(nReset)
  );
  DFFR_X1 _745_ (
    .CK(clk),
    .D(_001_),
    .Q(busy),
    .QN(_377_),
    .RN(nReset)
  );
  DFFR_X1 _746_ (
    .CK(clk),
    .D(_008_),
    .Q(sta_condition),
    .QN(_326_),
    .RN(nReset)
  );
  DFFR_X1 _747_ (
    .CK(clk),
    .D(_009_),
    .Q(sto_condition),
    .QN(_308_),
    .RN(nReset)
  );
  DFFS_X1 _748_ (
    .CK(clk),
    .D(_005_),
    .Q(sSCL),
    .QN(_310_),
    .SN(nReset)
  );
  DFFS_X1 _749_ (
    .CK(clk),
    .D(_006_),
    .Q(sSDA),
    .QN(_371_),
    .SN(nReset)
  );
  DFFS_X1 _750_ (
    .CK(clk),
    .D(sSCL),
    .Q(dSCL),
    .QN(_331_),
    .SN(nReset)
  );
  DFFS_X1 _751_ (
    .CK(clk),
    .D(sSDA),
    .Q(dSDA),
    .QN(_309_),
    .SN(nReset)
  );
  DFFR_X1 _752_ (
    .CK(clk),
    .D(_004_[0]),
    .Q(filter_cnt[0]),
    .QN(_010_),
    .RN(nReset)
  );
  DFFR_X1 _753_ (
    .CK(clk),
    .D(_004_[1]),
    .Q(filter_cnt[1]),
    .QN(_359_),
    .RN(nReset)
  );
  DFFR_X1 _754_ (
    .CK(clk),
    .D(_004_[2]),
    .Q(filter_cnt[2]),
    .QN(_319_),
    .RN(nReset)
  );
  DFFR_X1 _755_ (
    .CK(clk),
    .D(_004_[3]),
    .Q(filter_cnt[3]),
    .QN(_362_),
    .RN(nReset)
  );
  DFFR_X1 _756_ (
    .CK(clk),
    .D(_004_[4]),
    .Q(filter_cnt[4]),
    .QN(_317_),
    .RN(nReset)
  );
  DFFR_X1 _757_ (
    .CK(clk),
    .D(_004_[5]),
    .Q(filter_cnt[5]),
    .QN(_358_),
    .RN(nReset)
  );
  DFFR_X1 _758_ (
    .CK(clk),
    .D(_004_[6]),
    .Q(filter_cnt[6]),
    .QN(_321_),
    .RN(nReset)
  );
  DFFR_X1 _759_ (
    .CK(clk),
    .D(_004_[7]),
    .Q(filter_cnt[7]),
    .QN(_316_),
    .RN(nReset)
  );
  DFFR_X1 _760_ (
    .CK(clk),
    .D(_004_[8]),
    .Q(filter_cnt[8]),
    .QN(_361_),
    .RN(nReset)
  );
  DFFR_X1 _761_ (
    .CK(clk),
    .D(_004_[9]),
    .Q(filter_cnt[9]),
    .QN(_368_),
    .RN(nReset)
  );
  DFFR_X1 _762_ (
    .CK(clk),
    .D(_004_[10]),
    .Q(filter_cnt[10]),
    .QN(_318_),
    .RN(nReset)
  );
  DFFR_X1 _763_ (
    .CK(clk),
    .D(_004_[11]),
    .Q(filter_cnt[11]),
    .QN(_360_),
    .RN(nReset)
  );
  DFFR_X1 _764_ (
    .CK(clk),
    .D(_004_[12]),
    .Q(filter_cnt[12]),
    .QN(_372_),
    .RN(nReset)
  );
  DFFR_X1 _765_ (
    .CK(clk),
    .D(_004_[13]),
    .Q(filter_cnt[13]),
    .QN(_367_),
    .RN(nReset)
  );
  DFFR_X1 _766_ (
    .CK(clk),
    .D(scl_i),
    .Q(cSCL[0]),
    .QN(_356_),
    .RN(nReset)
  );
  DFFR_X1 _767_ (
    .CK(clk),
    .D(cSCL[0]),
    .Q(cSCL[1]),
    .QN(_341_),
    .RN(nReset)
  );
  DFFR_X1 _768_ (
    .CK(clk),
    .D(sda_i),
    .Q(cSDA[0]),
    .QN(_363_),
    .RN(nReset)
  );
  DFFR_X1 _769_ (
    .CK(clk),
    .D(cSDA[0]),
    .Q(cSDA[1]),
    .QN(_376_),
    .RN(nReset)
  );
  DFFS_X1 _770_ (
    .CK(clk),
    .D(_002_),
    .Q(clk_en),
    .QN(_365_),
    .SN(nReset)
  );
  DFFR_X1 _771_ (
    .CK(clk),
    .D(_007_),
    .Q(slave_wait),
    .QN(_355_),
    .RN(nReset)
  );
  DFF_X1 _772_ (
    .CK(clk),
    .D(scl_oen),
    .Q(dscl_oen),
    .QN(_370_)
  );
  assign c_state[17] = 1'h0;
  assign sda_o = 1'h0;
  assign scl_o = 1'h0;
endmodule

module i2c_master_byte_ctrl(clk, nReset, ena, clk_cnt, start, stop, read, write, ack_in, din, cmd_ack, ack_out, dout, i2c_busy, i2c_al, scl_i, scl_o, scl_oen, sda_i, sda_o, sda_oen
);
  input clk;
  wire clk;
  input nReset;
  wire nReset;
  input ena;
  wire ena;
  input [15:0] clk_cnt;
  wire [15:0] clk_cnt;
  input start;
  wire start;
  input stop;
  wire stop;
  input read;
  wire read;
  input write;
  wire write;
  input ack_in;
  wire ack_in;
  input [7:0] din;
  wire [7:0] din;
  output cmd_ack;
  wire cmd_ack;
  output ack_out;
  wire ack_out;
  output [7:0] dout;
  wire [7:0] dout;
  output i2c_busy;
  wire i2c_busy;
  output i2c_al;
  wire i2c_al;
  input scl_i;
  wire scl_i;
  output scl_o;
  wire scl_o;
  output scl_oen;
  wire scl_oen;
  input sda_i;
  wire sda_i;
  output sda_o;
  wire sda_o;
  output sda_oen;
  wire sda_oen;
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
  wire [5:0] c_state;
  wire core_ack;
  wire [3:0] core_cmd;
  wire core_rxd;
  wire core_txd;
  wire [2:0] dcnt;
  wire ld;
  wire shift;
  wire [7:0] sr;
  INV_X1 _131_ (
    .A(ld),
    .ZN(_075_)
  );
  INV_X1 _132_ (
    .A(sr[4]),
    .ZN(_076_)
  );
  INV_X1 _133_ (
    .A(sr[3]),
    .ZN(_077_)
  );
  INV_X1 _134_ (
    .A(din[4]),
    .ZN(_078_)
  );
  INV_X1 _135_ (
    .A(sr[2]),
    .ZN(_079_)
  );
  INV_X1 _136_ (
    .A(write),
    .ZN(_080_)
  );
  INV_X1 _137_ (
    .A(read),
    .ZN(_081_)
  );
  INV_X1 _138_ (
    .A(c_state[4]),
    .ZN(_082_)
  );
  INV_X1 _139_ (
    .A(c_state[3]),
    .ZN(_083_)
  );
  INV_X1 _140_ (
    .A(c_state[5]),
    .ZN(_084_)
  );
  INV_X1 _141_ (
    .A(c_state[2]),
    .ZN(_085_)
  );
  INV_X1 _142_ (
    .A(i2c_al),
    .ZN(_086_)
  );
  INV_X1 _143_ (
    .A(cmd_ack),
    .ZN(_087_)
  );
  INV_X1 _144_ (
    .A(shift),
    .ZN(_088_)
  );
  INV_X1 _145_ (
    .A(ack_out),
    .ZN(_089_)
  );
  NOR3_X1 _146_ (
    .A1(_080_),
    .A2(start),
    .A3(read),
    .ZN(_090_)
  );
  OR3_X1 _147_ (
    .A1(write),
    .A2(read),
    .A3(stop),
    .ZN(_091_)
  );
  NAND2_X1 _148_ (
    .A1(_087_),
    .A2(_091_),
    .ZN(_092_)
  );
  NAND3_X1 _149_ (
    .A1(_087_),
    .A2(c_state[0]),
    .A3(_091_),
    .ZN(_093_)
  );
  NOR2_X1 _150_ (
    .A1(i2c_al),
    .A2(_093_),
    .ZN(_094_)
  );
  NOR2_X1 _151_ (
    .A1(i2c_al),
    .A2(core_ack),
    .ZN(_095_)
  );
  AND2_X1 _152_ (
    .A1(_086_),
    .A2(core_ack),
    .ZN(_096_)
  );
  NOR3_X1 _153_ (
    .A1(dcnt[0]),
    .A2(dcnt[1]),
    .A3(dcnt[2]),
    .ZN(_097_)
  );
  OAI22_X1 _154_ (
    .A1(read),
    .A2(_084_),
    .B1(_097_),
    .B2(_083_),
    .ZN(_098_)
  );
  AOI222_X1 _155_ (
    .A1(_090_),
    .A2(_094_),
    .B1(_096_),
    .B2(_098_),
    .C1(_095_),
    .C2(c_state[3]),
    .ZN(_099_)
  );
  INV_X1 _156_ (
    .A(_099_),
    .ZN(_007_)
  );
  NAND2_X1 _157_ (
    .A1(c_state[2]),
    .A2(_095_),
    .ZN(_100_)
  );
  OAI211_X1 _158_ (
    .A(_096_),
    .B(_097_),
    .C1(c_state[4]),
    .C2(c_state[3]),
    .ZN(_101_)
  );
  NAND2_X1 _159_ (
    .A1(_100_),
    .A2(_101_),
    .ZN(_006_)
  );
  NOR2_X1 _160_ (
    .A1(start),
    .A2(_081_),
    .ZN(_102_)
  );
  OAI22_X1 _161_ (
    .A1(_081_),
    .A2(_084_),
    .B1(_097_),
    .B2(_082_),
    .ZN(_103_)
  );
  AOI222_X1 _162_ (
    .A1(c_state[4]),
    .A2(_095_),
    .B1(_096_),
    .B2(_103_),
    .C1(_102_),
    .C2(_094_),
    .ZN(_104_)
  );
  INV_X1 _163_ (
    .A(_104_),
    .ZN(_008_)
  );
  NOR3_X1 _164_ (
    .A1(write),
    .A2(start),
    .A3(read),
    .ZN(_026_)
  );
  AND3_X1 _165_ (
    .A1(c_state[2]),
    .A2(stop),
    .A3(_096_),
    .ZN(_027_)
  );
  AOI221_X1 _166_ (
    .A(_027_),
    .B1(_026_),
    .B2(_094_),
    .C1(c_state[1]),
    .C2(_095_),
    .ZN(_028_)
  );
  INV_X1 _167_ (
    .A(_028_),
    .ZN(_005_)
  );
  NAND2_X1 _168_ (
    .A1(c_state[0]),
    .A2(_092_),
    .ZN(_029_)
  );
  NAND2_X1 _169_ (
    .A1(c_state[2]),
    .A2(core_ack),
    .ZN(_030_)
  );
  NOR2_X1 _170_ (
    .A1(stop),
    .A2(_030_),
    .ZN(_031_)
  );
  AOI21_X1 _171_ (
    .A(_031_),
    .B1(_096_),
    .B2(c_state[1]),
    .ZN(_032_)
  );
  NAND3_X1 _172_ (
    .A1(_086_),
    .A2(_029_),
    .A3(_032_),
    .ZN(_004_)
  );
  AOI21_X1 _173_ (
    .A(c_state[2]),
    .B1(core_ack),
    .B2(c_state[4]),
    .ZN(_033_)
  );
  INV_X1 _174_ (
    .A(_033_),
    .ZN(_034_)
  );
  OAI21_X1 _175_ (
    .A(sr[7]),
    .B1(_085_),
    .B2(c_state[4]),
    .ZN(_035_)
  );
  AOI21_X1 _176_ (
    .A(_035_),
    .B1(core_ack),
    .B2(c_state[4]),
    .ZN(_036_)
  );
  AOI21_X1 _177_ (
    .A(_036_),
    .B1(_034_),
    .B2(ack_in),
    .ZN(_037_)
  );
  AOI21_X1 _178_ (
    .A(i2c_al),
    .B1(_030_),
    .B2(_037_),
    .ZN(_001_)
  );
  OAI21_X1 _179_ (
    .A(_082_),
    .B1(_083_),
    .B2(_097_),
    .ZN(_038_)
  );
  NAND2_X1 _180_ (
    .A1(_096_),
    .A2(_038_),
    .ZN(_039_)
  );
  INV_X1 _181_ (
    .A(_039_),
    .ZN(_003_)
  );
  AOI21_X1 _182_ (
    .A(_094_),
    .B1(_096_),
    .B2(c_state[5]),
    .ZN(_040_)
  );
  INV_X1 _183_ (
    .A(_040_),
    .ZN(_002_)
  );
  NOR2_X1 _184_ (
    .A1(i2c_al),
    .A2(_032_),
    .ZN(_000_)
  );
  NAND2_X1 _185_ (
    .A1(c_state[5]),
    .A2(_095_),
    .ZN(_041_)
  );
  NAND2_X1 _186_ (
    .A1(start),
    .A2(_086_),
    .ZN(_042_)
  );
  OAI21_X1 _187_ (
    .A(_041_),
    .B1(_042_),
    .B2(_093_),
    .ZN(_009_)
  );
  NOR2_X1 _188_ (
    .A1(ld),
    .A2(shift),
    .ZN(_043_)
  );
  NOR2_X1 _189_ (
    .A1(ld),
    .A2(_088_),
    .ZN(_044_)
  );
  NOR2_X1 _190_ (
    .A1(_075_),
    .A2(din[3]),
    .ZN(_045_)
  );
  AOI221_X1 _191_ (
    .A(_045_),
    .B1(_044_),
    .B2(_079_),
    .C1(_077_),
    .C2(_043_),
    .ZN(_010_)
  );
  OR2_X1 _192_ (
    .A1(dcnt[0]),
    .A2(_088_),
    .ZN(_046_)
  );
  OAI21_X1 _193_ (
    .A(dcnt[2]),
    .B1(_046_),
    .B2(dcnt[1]),
    .ZN(_047_)
  );
  NAND2_X1 _194_ (
    .A1(shift),
    .A2(_097_),
    .ZN(_048_)
  );
  NAND3_X1 _195_ (
    .A1(_075_),
    .A2(_047_),
    .A3(_048_),
    .ZN(_011_)
  );
  NAND2_X1 _196_ (
    .A1(ld),
    .A2(din[2]),
    .ZN(_049_)
  );
  AOI22_X1 _197_ (
    .A1(sr[2]),
    .A2(_043_),
    .B1(_044_),
    .B2(sr[1]),
    .ZN(_050_)
  );
  NAND2_X1 _198_ (
    .A1(_049_),
    .A2(_050_),
    .ZN(_012_)
  );
  MUX2_X1 _199_ (
    .A(sr[7]),
    .B(sr[6]),
    .S(shift),
    .Z(_051_)
  );
  MUX2_X1 _200_ (
    .A(_051_),
    .B(din[7]),
    .S(ld),
    .Z(_013_)
  );
  NAND2_X1 _201_ (
    .A1(ld),
    .A2(din[1]),
    .ZN(_052_)
  );
  AOI22_X1 _202_ (
    .A1(sr[1]),
    .A2(_043_),
    .B1(_044_),
    .B2(sr[0]),
    .ZN(_053_)
  );
  NAND2_X1 _203_ (
    .A1(_052_),
    .A2(_053_),
    .ZN(_014_)
  );
  NAND2_X1 _204_ (
    .A1(ld),
    .A2(din[0]),
    .ZN(_054_)
  );
  AOI22_X1 _205_ (
    .A1(sr[0]),
    .A2(_043_),
    .B1(_044_),
    .B2(core_rxd),
    .ZN(_055_)
  );
  NAND2_X1 _206_ (
    .A1(_054_),
    .A2(_055_),
    .ZN(_015_)
  );
  OR2_X1 _207_ (
    .A1(c_state[5]),
    .A2(c_state[1]),
    .ZN(_056_)
  );
  NOR4_X1 _208_ (
    .A1(c_state[4]),
    .A2(c_state[3]),
    .A3(c_state[2]),
    .A4(_056_),
    .ZN(_057_)
  );
  OAI211_X1 _209_ (
    .A(_086_),
    .B(_093_),
    .C1(_057_),
    .C2(c_state[0]),
    .ZN(_058_)
  );
  OAI21_X1 _210_ (
    .A(_095_),
    .B1(_056_),
    .B2(c_state[4]),
    .ZN(_059_)
  );
  OAI21_X1 _211_ (
    .A(_095_),
    .B1(c_state[2]),
    .B2(c_state[3]),
    .ZN(_060_)
  );
  AND3_X1 _212_ (
    .A1(_058_),
    .A2(_059_),
    .A3(_060_),
    .ZN(_061_)
  );
  AOI22_X1 _213_ (
    .A1(c_state[2]),
    .A2(stop),
    .B1(_026_),
    .B2(_057_),
    .ZN(_062_)
  );
  NOR2_X1 _214_ (
    .A1(i2c_al),
    .A2(_062_),
    .ZN(_063_)
  );
  MUX2_X1 _215_ (
    .A(core_cmd[1]),
    .B(_063_),
    .S(_061_),
    .Z(_016_)
  );
  AND3_X1 _216_ (
    .A1(start),
    .A2(_086_),
    .A3(_057_),
    .ZN(_064_)
  );
  MUX2_X1 _217_ (
    .A(core_cmd[0]),
    .B(_064_),
    .S(_061_),
    .Z(_017_)
  );
  AOI221_X1 _218_ (
    .A(_098_),
    .B1(_057_),
    .B2(_090_),
    .C1(_097_),
    .C2(c_state[4]),
    .ZN(_065_)
  );
  NOR2_X1 _219_ (
    .A1(i2c_al),
    .A2(_065_),
    .ZN(_066_)
  );
  MUX2_X1 _220_ (
    .A(core_cmd[2]),
    .B(_066_),
    .S(_061_),
    .Z(_018_)
  );
  AOI21_X1 _221_ (
    .A(ld),
    .B1(dcnt[1]),
    .B2(_046_),
    .ZN(_067_)
  );
  OAI21_X1 _222_ (
    .A(_067_),
    .B1(_046_),
    .B2(dcnt[1]),
    .ZN(_019_)
  );
  AOI21_X1 _223_ (
    .A(ld),
    .B1(dcnt[0]),
    .B2(_088_),
    .ZN(_068_)
  );
  NAND2_X1 _224_ (
    .A1(_046_),
    .A2(_068_),
    .ZN(_020_)
  );
  AOI221_X1 _225_ (
    .A(_103_),
    .B1(_057_),
    .B2(_102_),
    .C1(_097_),
    .C2(c_state[3]),
    .ZN(_069_)
  );
  NOR2_X1 _226_ (
    .A1(i2c_al),
    .A2(_069_),
    .ZN(_070_)
  );
  MUX2_X1 _227_ (
    .A(core_cmd[3]),
    .B(_070_),
    .S(_061_),
    .Z(_021_)
  );
  AOI222_X1 _228_ (
    .A1(din[6]),
    .A2(ld),
    .B1(sr[6]),
    .B2(_043_),
    .C1(_044_),
    .C2(sr[5]),
    .ZN(_071_)
  );
  INV_X1 _229_ (
    .A(_071_),
    .ZN(_022_)
  );
  OAI21_X1 _230_ (
    .A(_086_),
    .B1(_030_),
    .B2(core_rxd),
    .ZN(_072_)
  );
  AOI21_X1 _231_ (
    .A(_072_),
    .B1(_030_),
    .B2(_089_),
    .ZN(_023_)
  );
  AOI222_X1 _232_ (
    .A1(ld),
    .A2(din[5]),
    .B1(_044_),
    .B2(sr[4]),
    .C1(_043_),
    .C2(sr[5]),
    .ZN(_073_)
  );
  INV_X1 _233_ (
    .A(_073_),
    .ZN(_024_)
  );
  NOR3_X1 _234_ (
    .A1(ld),
    .A2(sr[3]),
    .A3(_088_),
    .ZN(_074_)
  );
  AOI221_X1 _235_ (
    .A(_074_),
    .B1(_043_),
    .B2(_076_),
    .C1(ld),
    .C2(_078_),
    .ZN(_025_)
  );
  DFFR_X1 _236_ (
    .CK(clk),
    .D(_015_),
    .Q(sr[0]),
    .QN(_121_),
    .RN(nReset)
  );
  DFFR_X1 _237_ (
    .CK(clk),
    .D(_014_),
    .Q(sr[1]),
    .QN(_116_),
    .RN(nReset)
  );
  DFFR_X1 _238_ (
    .CK(clk),
    .D(_012_),
    .Q(sr[2]),
    .QN(_118_),
    .RN(nReset)
  );
  DFFR_X1 _239_ (
    .CK(clk),
    .D(_010_),
    .Q(sr[3]),
    .QN(_120_),
    .RN(nReset)
  );
  DFFR_X1 _240_ (
    .CK(clk),
    .D(_025_),
    .Q(sr[4]),
    .QN(_130_),
    .RN(nReset)
  );
  DFFR_X1 _241_ (
    .CK(clk),
    .D(_024_),
    .Q(sr[5]),
    .QN(_106_),
    .RN(nReset)
  );
  DFFR_X1 _242_ (
    .CK(clk),
    .D(_022_),
    .Q(sr[6]),
    .QN(_127_),
    .RN(nReset)
  );
  DFFR_X1 _243_ (
    .CK(clk),
    .D(_013_),
    .Q(sr[7]),
    .QN(_117_),
    .RN(nReset)
  );
  DFFR_X1 _244_ (
    .CK(clk),
    .D(_020_),
    .Q(dcnt[0]),
    .QN(_126_),
    .RN(nReset)
  );
  DFFR_X1 _245_ (
    .CK(clk),
    .D(_019_),
    .Q(dcnt[1]),
    .QN(_111_),
    .RN(nReset)
  );
  DFFR_X1 _246_ (
    .CK(clk),
    .D(_011_),
    .Q(dcnt[2]),
    .QN(_119_),
    .RN(nReset)
  );
  DFFR_X1 _247_ (
    .CK(clk),
    .D(_017_),
    .Q(core_cmd[0]),
    .QN(_122_),
    .RN(nReset)
  );
  DFFR_X1 _248_ (
    .CK(clk),
    .D(_016_),
    .Q(core_cmd[1]),
    .QN(_114_),
    .RN(nReset)
  );
  DFFR_X1 _249_ (
    .CK(clk),
    .D(_018_),
    .Q(core_cmd[2]),
    .QN(_112_),
    .RN(nReset)
  );
  DFFR_X1 _250_ (
    .CK(clk),
    .D(_021_),
    .Q(core_cmd[3]),
    .QN(_109_),
    .RN(nReset)
  );
  DFFR_X1 _251_ (
    .CK(clk),
    .D(_023_),
    .Q(ack_out),
    .QN(_129_),
    .RN(nReset)
  );
  DFFS_X1 _252_ (
    .CK(clk),
    .D(_004_),
    .Q(c_state[0]),
    .QN(_123_),
    .SN(nReset)
  );
  DFFR_X1 _253_ (
    .CK(clk),
    .D(_005_),
    .Q(c_state[1]),
    .QN(_115_),
    .RN(nReset)
  );
  DFFR_X1 _254_ (
    .CK(clk),
    .D(_006_),
    .Q(c_state[2]),
    .QN(_128_),
    .RN(nReset)
  );
  DFFR_X1 _255_ (
    .CK(clk),
    .D(_007_),
    .Q(c_state[3]),
    .QN(_113_),
    .RN(nReset)
  );
  DFFR_X1 _256_ (
    .CK(clk),
    .D(_008_),
    .Q(c_state[4]),
    .QN(_125_),
    .RN(nReset)
  );
  DFFR_X1 _257_ (
    .CK(clk),
    .D(_009_),
    .Q(c_state[5]),
    .QN(_110_),
    .RN(nReset)
  );
  DFFR_X1 _258_ (
    .CK(clk),
    .D(_000_),
    .Q(cmd_ack),
    .QN(_107_),
    .RN(nReset)
  );
  DFFR_X1 _259_ (
    .CK(clk),
    .D(_001_),
    .Q(core_txd),
    .QN(_105_),
    .RN(nReset)
  );
  DFFR_X1 _260_ (
    .CK(clk),
    .D(_003_),
    .Q(shift),
    .QN(_124_),
    .RN(nReset)
  );
  DFFR_X1 _261_ (
    .CK(clk),
    .D(_002_),
    .Q(ld),
    .QN(_108_),
    .RN(nReset)
  );
  i2c_master_bit_ctrl bit_controller (
    .al(i2c_al),
    .busy(i2c_busy),
    .clk(clk),
    .clk_cnt(clk_cnt),
    .cmd(core_cmd),
    .cmd_ack(core_ack),
    .din(core_txd),
    .dout(core_rxd),
    .ena(ena),
    .nReset(nReset),
    .scl_i(scl_i),
    .scl_o(scl_o),
    .scl_oen(scl_oen),
    .sda_i(sda_i),
    .sda_o(sda_o),
    .sda_oen(sda_oen)
  );
  assign dout = sr;
endmodule

module pulp_i2c_wrap(clk, rst_n, secure_mode, s_awaddr, s_awvalid, s_awready, s_wdata, s_wstrb, s_wvalid, s_wready, s_bresp, s_bvalid, s_bready, s_araddr, s_arvalid, s_arready, s_rdata, s_rresp, s_rvalid, s_rready, i2c_sda
, i2c_scl, irq);
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
  inout i2c_sda;
  wire i2c_sda;
  inout i2c_scl;
  wire i2c_scl;
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
  wire [11:0] apb_paddr;
  wire apb_penable;
  wire [31:0] apb_prdata;
  wire apb_pready;
  wire apb_psel;
  wire apb_pslverr;
  wire [31:0] apb_pwdata;
  wire apb_pwrite;
  wire bus_stuck_r;
  wire [6:0] captured_i2c_addr;
  wire clr_stuck;
  wire clr_stuck_r;
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
  wire i2c_penable_gated;
  wire [31:0] i2c_prdata_raw;
  wire i2c_pready_raw;
  wire i2c_psel_gated;
  wire i2c_pslverr_raw;
  wire [31:0] lrd_rdata_r;
  wire [1:0] lrd_state_r;
  wire [11:0] lwr_addr_r;
  wire [2:0] lwr_state_r;
  wire scl_pad_i;
  wire scl_pad_o;
  wire scl_padoen_o;
  wire sda_pad_i;
  wire sda_pad_o;
  wire sda_padoen_o;
  wire [23:0] stuck_cnt_r;
  wire [6:0] \whitelist_addr[0] ;
  wire [6:0] \whitelist_addr[1] ;
  wire [6:0] \whitelist_addr[2] ;
  wire [6:0] \whitelist_addr[3] ;
  wire whitelist_en;
  INV_X1 _339_ (
    .A(stuck_cnt_r[6]),
    .ZN(_081_)
  );
  INV_X1 _340_ (
    .A(stuck_cnt_r[7]),
    .ZN(_082_)
  );
  INV_X1 _341_ (
    .A(stuck_cnt_r[8]),
    .ZN(_083_)
  );
  INV_X1 _342_ (
    .A(stuck_cnt_r[10]),
    .ZN(_084_)
  );
  INV_X1 _343_ (
    .A(stuck_cnt_r[15]),
    .ZN(_085_)
  );
  INV_X1 _344_ (
    .A(stuck_cnt_r[1]),
    .ZN(_086_)
  );
  INV_X1 _345_ (
    .A(stuck_cnt_r[0]),
    .ZN(_087_)
  );
  INV_X1 _346_ (
    .A(s_araddr[3]),
    .ZN(_088_)
  );
  INV_X1 _347_ (
    .A(s_araddr[10]),
    .ZN(_089_)
  );
  INV_X1 _348_ (
    .A(whitelist_en),
    .ZN(_090_)
  );
  INV_X1 _349_ (
    .A(lrd_state_r[1]),
    .ZN(_091_)
  );
  INV_X1 _350_ (
    .A(lwr_state_r[1]),
    .ZN(_092_)
  );
  INV_X1 _351_ (
    .A(s_arvalid),
    .ZN(_093_)
  );
  INV_X1 _352_ (
    .A(lrd_state_r[0]),
    .ZN(_094_)
  );
  INV_X1 _353_ (
    .A(lwr_state_r[2]),
    .ZN(_095_)
  );
  INV_X1 _354_ (
    .A(bus_stuck_r),
    .ZN(_096_)
  );
  INV_X1 _355_ (
    .A(lwr_addr_r[6]),
    .ZN(_097_)
  );
  INV_X1 _356_ (
    .A(lwr_addr_r[5]),
    .ZN(_098_)
  );
  INV_X1 _357_ (
    .A(lwr_addr_r[4]),
    .ZN(_099_)
  );
  INV_X1 _358_ (
    .A(lwr_addr_r[3]),
    .ZN(_100_)
  );
  INV_X1 _359_ (
    .A(lwr_addr_r[7]),
    .ZN(_101_)
  );
  INV_X1 _360_ (
    .A(lwr_addr_r[2]),
    .ZN(_102_)
  );
  INV_X1 _361_ (
    .A(s_wdata[8]),
    .ZN(_103_)
  );
  INV_X1 _362_ (
    .A(s_awvalid),
    .ZN(_104_)
  );
  INV_X1 _363_ (
    .A(s_awaddr[3]),
    .ZN(_105_)
  );
  INV_X1 _364_ (
    .A(lwr_state_r[0]),
    .ZN(_106_)
  );
  INV_X1 _365_ (
    .A(\whitelist_addr[3] [6]),
    .ZN(_107_)
  );
  INV_X1 _366_ (
    .A(captured_i2c_addr[0]),
    .ZN(_108_)
  );
  INV_X1 _367_ (
    .A(\whitelist_addr[3] [0]),
    .ZN(_109_)
  );
  INV_X1 _368_ (
    .A(captured_i2c_addr[3]),
    .ZN(_110_)
  );
  INV_X1 _369_ (
    .A(captured_i2c_addr[2]),
    .ZN(_111_)
  );
  INV_X1 _370_ (
    .A(captured_i2c_addr[4]),
    .ZN(_112_)
  );
  INV_X1 _371_ (
    .A(\whitelist_addr[3] [4]),
    .ZN(_113_)
  );
  INV_X1 _372_ (
    .A(captured_i2c_addr[5]),
    .ZN(_114_)
  );
  INV_X1 _373_ (
    .A(\whitelist_addr[3] [5]),
    .ZN(_115_)
  );
  INV_X1 _374_ (
    .A(\whitelist_addr[0] [5]),
    .ZN(_116_)
  );
  INV_X1 _375_ (
    .A(\whitelist_addr[1] [2]),
    .ZN(_117_)
  );
  INV_X1 _376_ (
    .A(\whitelist_addr[1] [3]),
    .ZN(_118_)
  );
  INV_X1 _377_ (
    .A(apb_penable),
    .ZN(_119_)
  );
  INV_X1 _378_ (
    .A(apb_psel),
    .ZN(_120_)
  );
  INV_X1 _379_ (
    .A(apb_pwrite),
    .ZN(_121_)
  );
  INV_X1 _380_ (
    .A(apb_paddr[2]),
    .ZN(_122_)
  );
  INV_X1 _381_ (
    .A(fwd_arready),
    .ZN(_123_)
  );
  INV_X1 _382_ (
    .A(fwd_awready),
    .ZN(_124_)
  );
  AND2_X1 _383_ (
    .A1(fwd_rresp[0]),
    .A2(_091_),
    .ZN(s_rresp[0])
  );
  AND2_X1 _384_ (
    .A1(_091_),
    .A2(fwd_rdata[30]),
    .ZN(s_rdata[30])
  );
  AND2_X1 _385_ (
    .A1(_091_),
    .A2(fwd_rdata[29]),
    .ZN(s_rdata[29])
  );
  AND2_X1 _386_ (
    .A1(_091_),
    .A2(fwd_rdata[28]),
    .ZN(s_rdata[28])
  );
  AND2_X1 _387_ (
    .A1(_091_),
    .A2(fwd_rdata[27]),
    .ZN(s_rdata[27])
  );
  AND2_X1 _388_ (
    .A1(_091_),
    .A2(fwd_rdata[26]),
    .ZN(s_rdata[26])
  );
  AND2_X1 _389_ (
    .A1(_091_),
    .A2(fwd_rdata[25]),
    .ZN(s_rdata[25])
  );
  AND2_X1 _390_ (
    .A1(_091_),
    .A2(fwd_rdata[24]),
    .ZN(s_rdata[24])
  );
  AND2_X1 _391_ (
    .A1(_091_),
    .A2(fwd_rdata[23]),
    .ZN(s_rdata[23])
  );
  AND2_X1 _392_ (
    .A1(_091_),
    .A2(fwd_rdata[22]),
    .ZN(s_rdata[22])
  );
  AND2_X1 _393_ (
    .A1(_091_),
    .A2(fwd_rdata[21]),
    .ZN(s_rdata[21])
  );
  AND2_X1 _394_ (
    .A1(_091_),
    .A2(fwd_rdata[20]),
    .ZN(s_rdata[20])
  );
  AND2_X1 _395_ (
    .A1(_091_),
    .A2(fwd_rdata[19]),
    .ZN(s_rdata[19])
  );
  AND2_X1 _396_ (
    .A1(_091_),
    .A2(fwd_rdata[18]),
    .ZN(s_rdata[18])
  );
  AND2_X1 _397_ (
    .A1(_091_),
    .A2(fwd_rdata[17]),
    .ZN(s_rdata[17])
  );
  AND2_X1 _398_ (
    .A1(_091_),
    .A2(fwd_rdata[16]),
    .ZN(s_rdata[16])
  );
  AND2_X1 _399_ (
    .A1(_091_),
    .A2(fwd_rdata[15]),
    .ZN(s_rdata[15])
  );
  AND2_X1 _400_ (
    .A1(_091_),
    .A2(fwd_rdata[14]),
    .ZN(s_rdata[14])
  );
  AND2_X1 _401_ (
    .A1(_091_),
    .A2(fwd_rdata[13]),
    .ZN(s_rdata[13])
  );
  AND2_X1 _402_ (
    .A1(_091_),
    .A2(fwd_rdata[12]),
    .ZN(s_rdata[12])
  );
  AND2_X1 _403_ (
    .A1(_091_),
    .A2(fwd_rdata[11]),
    .ZN(s_rdata[11])
  );
  AND2_X1 _404_ (
    .A1(_091_),
    .A2(fwd_rdata[10]),
    .ZN(s_rdata[10])
  );
  AND2_X1 _405_ (
    .A1(_091_),
    .A2(fwd_rdata[9]),
    .ZN(s_rdata[9])
  );
  AND2_X1 _406_ (
    .A1(_091_),
    .A2(fwd_rdata[8]),
    .ZN(s_rdata[8])
  );
  AND2_X1 _407_ (
    .A1(_091_),
    .A2(fwd_rdata[7]),
    .ZN(s_rdata[7])
  );
  AND2_X1 _408_ (
    .A1(_091_),
    .A2(fwd_rdata[6]),
    .ZN(s_rdata[6])
  );
  AND2_X1 _409_ (
    .A1(_091_),
    .A2(fwd_rdata[5]),
    .ZN(s_rdata[5])
  );
  AND2_X1 _410_ (
    .A1(_091_),
    .A2(fwd_rdata[4]),
    .ZN(s_rdata[4])
  );
  AND2_X1 _411_ (
    .A1(_091_),
    .A2(fwd_rdata[3]),
    .ZN(s_rdata[3])
  );
  AND2_X1 _412_ (
    .A1(_091_),
    .A2(fwd_rdata[2]),
    .ZN(s_rdata[2])
  );
  MUX2_X1 _413_ (
    .A(fwd_rdata[1]),
    .B(lrd_rdata_r[1]),
    .S(lrd_state_r[1]),
    .Z(s_rdata[1])
  );
  MUX2_X1 _414_ (
    .A(fwd_rdata[0]),
    .B(lrd_rdata_r[0]),
    .S(lrd_state_r[1]),
    .Z(s_rdata[0])
  );
  AND2_X1 _415_ (
    .A1(fwd_bresp[0]),
    .A2(_092_),
    .ZN(s_bresp[0])
  );
  NOR3_X1 _416_ (
    .A1(s_araddr[11]),
    .A2(s_araddr[8]),
    .A3(s_araddr[9]),
    .ZN(_125_)
  );
  NAND4_X1 _417_ (
    .A1(s_araddr[5]),
    .A2(s_araddr[4]),
    .A3(s_araddr[7]),
    .A4(_089_),
    .ZN(_126_)
  );
  NOR2_X1 _418_ (
    .A1(s_araddr[0]),
    .A2(s_araddr[1]),
    .ZN(_127_)
  );
  NAND4_X1 _419_ (
    .A1(s_araddr[6]),
    .A2(_088_),
    .A3(_125_),
    .A4(_127_),
    .ZN(_128_)
  );
  NOR2_X1 _420_ (
    .A1(_126_),
    .A2(_128_),
    .ZN(_129_)
  );
  NOR3_X1 _421_ (
    .A1(_093_),
    .A2(_126_),
    .A3(_128_),
    .ZN(_130_)
  );
  NAND2_X1 _422_ (
    .A1(lrd_state_r[1]),
    .A2(s_rready),
    .ZN(_131_)
  );
  OAI21_X1 _423_ (
    .A(_131_),
    .B1(_130_),
    .B2(_094_),
    .ZN(_002_)
  );
  NAND2_X1 _424_ (
    .A1(s_wvalid),
    .A2(lwr_state_r[2]),
    .ZN(_132_)
  );
  OAI21_X1 _425_ (
    .A(_132_),
    .B1(s_bready),
    .B2(_092_),
    .ZN(_005_)
  );
  OR2_X1 _426_ (
    .A1(lwr_addr_r[8]),
    .A2(lwr_addr_r[9]),
    .ZN(_133_)
  );
  NOR4_X1 _427_ (
    .A1(lwr_addr_r[10]),
    .A2(lwr_addr_r[11]),
    .A3(_132_),
    .A4(_133_),
    .ZN(_134_)
  );
  NAND4_X1 _428_ (
    .A1(lwr_addr_r[6]),
    .A2(lwr_addr_r[5]),
    .A3(lwr_addr_r[4]),
    .A4(_100_),
    .ZN(_135_)
  );
  NOR4_X1 _429_ (
    .A1(lwr_addr_r[0]),
    .A2(_101_),
    .A3(lwr_addr_r[1]),
    .A4(_135_),
    .ZN(_136_)
  );
  AND4_X1 _430_ (
    .A1(lwr_addr_r[2]),
    .A2(s_wdata[1]),
    .A3(_134_),
    .A4(_136_),
    .ZN(_001_)
  );
  NAND2_X1 _431_ (
    .A1(lrd_state_r[0]),
    .A2(_130_),
    .ZN(_137_)
  );
  OAI21_X1 _432_ (
    .A(_137_),
    .B1(s_rready),
    .B2(_091_),
    .ZN(_003_)
  );
  AND3_X1 _433_ (
    .A1(stuck_cnt_r[15]),
    .A2(stuck_cnt_r[16]),
    .A3(stuck_cnt_r[17]),
    .ZN(_138_)
  );
  NAND2_X1 _434_ (
    .A1(stuck_cnt_r[18]),
    .A2(_138_),
    .ZN(_139_)
  );
  NOR3_X1 _435_ (
    .A1(stuck_cnt_r[5]),
    .A2(stuck_cnt_r[6]),
    .A3(stuck_cnt_r[7]),
    .ZN(_140_)
  );
  NOR4_X1 _436_ (
    .A1(stuck_cnt_r[9]),
    .A2(stuck_cnt_r[10]),
    .A3(stuck_cnt_r[11]),
    .A4(stuck_cnt_r[12]),
    .ZN(_141_)
  );
  OAI21_X1 _437_ (
    .A(_141_),
    .B1(_140_),
    .B2(_083_),
    .ZN(_142_)
  );
  AOI21_X1 _438_ (
    .A(stuck_cnt_r[14]),
    .B1(_142_),
    .B2(stuck_cnt_r[13]),
    .ZN(_143_)
  );
  OR3_X1 _439_ (
    .A1(stuck_cnt_r[21]),
    .A2(stuck_cnt_r[22]),
    .A3(stuck_cnt_r[23]),
    .ZN(_144_)
  );
  NOR3_X1 _440_ (
    .A1(stuck_cnt_r[19]),
    .A2(stuck_cnt_r[20]),
    .A3(_144_),
    .ZN(_145_)
  );
  OAI21_X1 _441_ (
    .A(_145_),
    .B1(_143_),
    .B2(_139_),
    .ZN(_146_)
  );
  NOR2_X1 _442_ (
    .A1(secure_mode),
    .A2(i2c_scl),
    .ZN(_147_)
  );
  OR2_X1 _443_ (
    .A1(secure_mode),
    .A2(i2c_scl),
    .ZN(_148_)
  );
  NAND3_X1 _444_ (
    .A1(_096_),
    .A2(_146_),
    .A3(_147_),
    .ZN(_149_)
  );
  OAI21_X1 _445_ (
    .A(_149_),
    .B1(clr_stuck_r),
    .B2(_096_),
    .ZN(_000_)
  );
  NOR4_X1 _446_ (
    .A1(s_awaddr[10]),
    .A2(s_awaddr[11]),
    .A3(s_awaddr[8]),
    .A4(s_awaddr[9]),
    .ZN(_150_)
  );
  NAND4_X1 _447_ (
    .A1(s_awaddr[5]),
    .A2(s_awaddr[4]),
    .A3(_105_),
    .A4(s_awaddr[7]),
    .ZN(_151_)
  );
  NOR2_X1 _448_ (
    .A1(s_awaddr[0]),
    .A2(s_awaddr[1]),
    .ZN(_152_)
  );
  NAND4_X1 _449_ (
    .A1(s_awaddr[6]),
    .A2(s_awvalid),
    .A3(_150_),
    .A4(_152_),
    .ZN(_153_)
  );
  NOR2_X1 _450_ (
    .A1(_151_),
    .A2(_153_),
    .ZN(_154_)
  );
  NAND2_X1 _451_ (
    .A1(lwr_state_r[0]),
    .A2(_154_),
    .ZN(_155_)
  );
  OAI21_X1 _452_ (
    .A(_155_),
    .B1(_095_),
    .B2(s_wvalid),
    .ZN(_006_)
  );
  XOR2_X1 _453_ (
    .A(captured_i2c_addr[1]),
    .B(\whitelist_addr[1] [1]),
    .Z(_156_)
  );
  AOI22_X1 _454_ (
    .A1(_111_),
    .A2(\whitelist_addr[1] [2]),
    .B1(_118_),
    .B2(captured_i2c_addr[3]),
    .ZN(_157_)
  );
  XOR2_X1 _455_ (
    .A(captured_i2c_addr[6]),
    .B(\whitelist_addr[1] [6]),
    .Z(_158_)
  );
  XNOR2_X1 _456_ (
    .A(captured_i2c_addr[5]),
    .B(\whitelist_addr[1] [5]),
    .ZN(_159_)
  );
  AOI221_X1 _457_ (
    .A(_158_),
    .B1(\whitelist_addr[1] [3]),
    .B2(_110_),
    .C1(_108_),
    .C2(\whitelist_addr[1] [0]),
    .ZN(_160_)
  );
  NAND3_X1 _458_ (
    .A1(_157_),
    .A2(_159_),
    .A3(_160_),
    .ZN(_161_)
  );
  AOI221_X1 _459_ (
    .A(_156_),
    .B1(\whitelist_addr[1] [4]),
    .B2(_112_),
    .C1(captured_i2c_addr[2]),
    .C2(_117_),
    .ZN(_162_)
  );
  OAI221_X1 _460_ (
    .A(_162_),
    .B1(\whitelist_addr[1] [4]),
    .B2(_112_),
    .C1(_108_),
    .C2(\whitelist_addr[1] [0]),
    .ZN(_163_)
  );
  XOR2_X1 _461_ (
    .A(captured_i2c_addr[0]),
    .B(\whitelist_addr[2] [0]),
    .Z(_164_)
  );
  XOR2_X1 _462_ (
    .A(captured_i2c_addr[1]),
    .B(\whitelist_addr[2] [1]),
    .Z(_165_)
  );
  XOR2_X1 _463_ (
    .A(captured_i2c_addr[6]),
    .B(\whitelist_addr[2] [6]),
    .Z(_166_)
  );
  XNOR2_X1 _464_ (
    .A(captured_i2c_addr[4]),
    .B(\whitelist_addr[2] [4]),
    .ZN(_167_)
  );
  XNOR2_X1 _465_ (
    .A(captured_i2c_addr[3]),
    .B(\whitelist_addr[2] [3]),
    .ZN(_168_)
  );
  XNOR2_X1 _466_ (
    .A(captured_i2c_addr[5]),
    .B(\whitelist_addr[2] [5]),
    .ZN(_169_)
  );
  XOR2_X1 _467_ (
    .A(captured_i2c_addr[2]),
    .B(\whitelist_addr[2] [2]),
    .Z(_170_)
  );
  NOR4_X1 _468_ (
    .A1(_164_),
    .A2(_165_),
    .A3(_166_),
    .A4(_170_),
    .ZN(_171_)
  );
  NAND4_X1 _469_ (
    .A1(_167_),
    .A2(_168_),
    .A3(_169_),
    .A4(_171_),
    .ZN(_172_)
  );
  OAI22_X1 _470_ (
    .A1(_111_),
    .A2(\whitelist_addr[3] [2]),
    .B1(captured_i2c_addr[4]),
    .B2(_113_),
    .ZN(_173_)
  );
  OAI22_X1 _471_ (
    .A1(captured_i2c_addr[6]),
    .A2(_107_),
    .B1(_110_),
    .B2(\whitelist_addr[3] [3]),
    .ZN(_174_)
  );
  AOI22_X1 _472_ (
    .A1(captured_i2c_addr[4]),
    .A2(_113_),
    .B1(_114_),
    .B2(\whitelist_addr[3] [5]),
    .ZN(_175_)
  );
  AOI22_X1 _473_ (
    .A1(captured_i2c_addr[6]),
    .A2(_107_),
    .B1(captured_i2c_addr[0]),
    .B2(_109_),
    .ZN(_176_)
  );
  AOI222_X1 _474_ (
    .A1(_110_),
    .A2(\whitelist_addr[3] [3]),
    .B1(_111_),
    .B2(\whitelist_addr[3] [2]),
    .C1(captured_i2c_addr[5]),
    .C2(_115_),
    .ZN(_177_)
  );
  XOR2_X1 _475_ (
    .A(captured_i2c_addr[1]),
    .B(\whitelist_addr[3] [1]),
    .Z(_178_)
  );
  AOI21_X1 _476_ (
    .A(_178_),
    .B1(\whitelist_addr[3] [0]),
    .B2(_108_),
    .ZN(_179_)
  );
  NAND4_X1 _477_ (
    .A1(_175_),
    .A2(_176_),
    .A3(_177_),
    .A4(_179_),
    .ZN(_180_)
  );
  NOR3_X1 _478_ (
    .A1(_173_),
    .A2(_174_),
    .A3(_180_),
    .ZN(_181_)
  );
  XOR2_X1 _479_ (
    .A(captured_i2c_addr[3]),
    .B(\whitelist_addr[0] [3]),
    .Z(_182_)
  );
  XOR2_X1 _480_ (
    .A(captured_i2c_addr[0]),
    .B(\whitelist_addr[0] [0]),
    .Z(_183_)
  );
  XOR2_X1 _481_ (
    .A(captured_i2c_addr[2]),
    .B(\whitelist_addr[0] [2]),
    .Z(_184_)
  );
  XNOR2_X1 _482_ (
    .A(captured_i2c_addr[6]),
    .B(\whitelist_addr[0] [6]),
    .ZN(_185_)
  );
  XOR2_X1 _483_ (
    .A(captured_i2c_addr[1]),
    .B(\whitelist_addr[0] [1]),
    .Z(_186_)
  );
  AOI211_X1 _484_ (
    .A(_183_),
    .B(_184_),
    .C1(_114_),
    .C2(\whitelist_addr[0] [5]),
    .ZN(_187_)
  );
  XNOR2_X1 _485_ (
    .A(captured_i2c_addr[4]),
    .B(\whitelist_addr[0] [4]),
    .ZN(_188_)
  );
  AOI211_X1 _486_ (
    .A(_182_),
    .B(_186_),
    .C1(captured_i2c_addr[5]),
    .C2(_116_),
    .ZN(_189_)
  );
  NAND4_X1 _487_ (
    .A1(_185_),
    .A2(_187_),
    .A3(_188_),
    .A4(_189_),
    .ZN(_190_)
  );
  OAI211_X1 _488_ (
    .A(_172_),
    .B(_190_),
    .C1(_161_),
    .C2(_163_),
    .ZN(_191_)
  );
  NOR4_X1 _489_ (
    .A1(apb_paddr[6]),
    .A2(apb_paddr[5]),
    .A3(apb_paddr[11]),
    .A4(apb_paddr[8]),
    .ZN(_192_)
  );
  NOR3_X1 _490_ (
    .A1(_120_),
    .A2(_121_),
    .A3(apb_paddr[0]),
    .ZN(_193_)
  );
  NOR4_X1 _491_ (
    .A1(apb_paddr[7]),
    .A2(apb_paddr[4]),
    .A3(apb_paddr[10]),
    .A4(apb_paddr[9]),
    .ZN(_194_)
  );
  NOR4_X1 _492_ (
    .A1(_119_),
    .A2(apb_paddr[3]),
    .A3(_122_),
    .A4(apb_paddr[1]),
    .ZN(_195_)
  );
  NAND4_X1 _493_ (
    .A1(_192_),
    .A2(_193_),
    .A3(_194_),
    .A4(_195_),
    .ZN(_196_)
  );
  NOR4_X1 _494_ (
    .A1(_090_),
    .A2(_181_),
    .A3(_191_),
    .A4(_196_),
    .ZN(_197_)
  );
  OR2_X1 _495_ (
    .A1(bus_stuck_r),
    .A2(_197_),
    .ZN(_198_)
  );
  OR2_X1 _496_ (
    .A1(i2c_pslverr_raw),
    .A2(_198_),
    .ZN(apb_pslverr)
  );
  OR2_X1 _497_ (
    .A1(i2c_pready_raw),
    .A2(_198_),
    .ZN(apb_pready)
  );
  NOR2_X1 _498_ (
    .A1(_119_),
    .A2(_198_),
    .ZN(i2c_penable_gated)
  );
  NOR2_X1 _499_ (
    .A1(_120_),
    .A2(_198_),
    .ZN(i2c_psel_gated)
  );
  AND2_X1 _500_ (
    .A1(_091_),
    .A2(fwd_rresp[1]),
    .ZN(s_rresp[1])
  );
  AND2_X1 _501_ (
    .A1(_091_),
    .A2(fwd_rdata[31]),
    .ZN(s_rdata[31])
  );
  OR2_X1 _502_ (
    .A1(lrd_state_r[1]),
    .A2(fwd_rvalid),
    .ZN(s_rvalid)
  );
  OAI21_X1 _503_ (
    .A(_137_),
    .B1(_130_),
    .B2(_123_),
    .ZN(s_arready)
  );
  AND2_X1 _504_ (
    .A1(_092_),
    .A2(fwd_bresp[1]),
    .ZN(s_bresp[1])
  );
  NAND2_X1 _505_ (
    .A1(lwr_state_r[1]),
    .A2(s_bready),
    .ZN(_199_)
  );
  OAI21_X1 _506_ (
    .A(_199_),
    .B1(_154_),
    .B2(_106_),
    .ZN(_004_)
  );
  OR2_X1 _507_ (
    .A1(lwr_state_r[1]),
    .A2(fwd_bvalid),
    .ZN(s_bvalid)
  );
  OR2_X1 _508_ (
    .A1(lwr_state_r[2]),
    .A2(fwd_wready),
    .ZN(s_wready)
  );
  OAI21_X1 _509_ (
    .A(_155_),
    .B1(_154_),
    .B2(_124_),
    .ZN(s_awready)
  );
  NOR2_X1 _510_ (
    .A1(_093_),
    .A2(_129_),
    .ZN(fwd_arvalid)
  );
  AND2_X1 _511_ (
    .A1(s_wvalid),
    .A2(lwr_state_r[0]),
    .ZN(fwd_wvalid)
  );
  NOR2_X1 _512_ (
    .A1(_104_),
    .A2(_154_),
    .ZN(fwd_awvalid)
  );
  OAI211_X1 _513_ (
    .A(_096_),
    .B(_145_),
    .C1(_143_),
    .C2(_139_),
    .ZN(_200_)
  );
  INV_X1 _514_ (
    .A(_200_),
    .ZN(_201_)
  );
  NAND2_X1 _515_ (
    .A1(_147_),
    .A2(_200_),
    .ZN(_202_)
  );
  AND2_X1 _516_ (
    .A1(stuck_cnt_r[22]),
    .A2(_147_),
    .ZN(_007_)
  );
  AND2_X1 _517_ (
    .A1(stuck_cnt_r[21]),
    .A2(_147_),
    .ZN(_008_)
  );
  AND2_X1 _518_ (
    .A1(stuck_cnt_r[20]),
    .A2(_147_),
    .ZN(_009_)
  );
  NAND2_X1 _519_ (
    .A1(lrd_rdata_r[1]),
    .A2(_137_),
    .ZN(_203_)
  );
  AND2_X1 _520_ (
    .A1(s_araddr[2]),
    .A2(_129_),
    .ZN(_204_)
  );
  NAND2_X1 _521_ (
    .A1(bus_stuck_r),
    .A2(_204_),
    .ZN(_205_)
  );
  OAI21_X1 _522_ (
    .A(_203_),
    .B1(_205_),
    .B2(_137_),
    .ZN(_010_)
  );
  AND2_X1 _523_ (
    .A1(stuck_cnt_r[19]),
    .A2(_147_),
    .ZN(_011_)
  );
  AND3_X1 _524_ (
    .A1(stuck_cnt_r[4]),
    .A2(stuck_cnt_r[5]),
    .A3(stuck_cnt_r[6]),
    .ZN(_206_)
  );
  AND4_X1 _525_ (
    .A1(stuck_cnt_r[2]),
    .A2(stuck_cnt_r[3]),
    .A3(stuck_cnt_r[1]),
    .A4(stuck_cnt_r[0]),
    .ZN(_207_)
  );
  AND4_X1 _526_ (
    .A1(stuck_cnt_r[7]),
    .A2(stuck_cnt_r[8]),
    .A3(stuck_cnt_r[9]),
    .A4(stuck_cnt_r[10]),
    .ZN(_208_)
  );
  AND2_X1 _527_ (
    .A1(stuck_cnt_r[4]),
    .A2(_207_),
    .ZN(_209_)
  );
  NAND3_X1 _528_ (
    .A1(stuck_cnt_r[5]),
    .A2(stuck_cnt_r[6]),
    .A3(_209_),
    .ZN(_210_)
  );
  NOR3_X1 _529_ (
    .A1(_082_),
    .A2(_083_),
    .A3(_210_),
    .ZN(_211_)
  );
  AND3_X1 _530_ (
    .A1(_206_),
    .A2(_207_),
    .A3(_208_),
    .ZN(_212_)
  );
  NAND3_X1 _531_ (
    .A1(_206_),
    .A2(_207_),
    .A3(_208_),
    .ZN(_213_)
  );
  AOI21_X1 _532_ (
    .A(_213_),
    .B1(_200_),
    .B2(_147_),
    .ZN(_214_)
  );
  AND3_X1 _533_ (
    .A1(stuck_cnt_r[11]),
    .A2(stuck_cnt_r[12]),
    .A3(_212_),
    .ZN(_215_)
  );
  NAND3_X1 _534_ (
    .A1(stuck_cnt_r[11]),
    .A2(stuck_cnt_r[12]),
    .A3(_212_),
    .ZN(_216_)
  );
  AOI21_X1 _535_ (
    .A(_216_),
    .B1(_200_),
    .B2(_147_),
    .ZN(_217_)
  );
  NAND3_X1 _536_ (
    .A1(stuck_cnt_r[13]),
    .A2(stuck_cnt_r[14]),
    .A3(_215_),
    .ZN(_218_)
  );
  AOI21_X1 _537_ (
    .A(_218_),
    .B1(_200_),
    .B2(_147_),
    .ZN(_219_)
  );
  AOI21_X1 _538_ (
    .A(stuck_cnt_r[18]),
    .B1(_138_),
    .B2(_219_),
    .ZN(_220_)
  );
  NOR2_X1 _539_ (
    .A1(_148_),
    .A2(_220_),
    .ZN(_012_)
  );
  AOI211_X1 _540_ (
    .A(_085_),
    .B(_218_),
    .C1(_200_),
    .C2(_147_),
    .ZN(_221_)
  );
  AOI21_X1 _541_ (
    .A(stuck_cnt_r[17]),
    .B1(_221_),
    .B2(stuck_cnt_r[16]),
    .ZN(_222_)
  );
  AOI211_X1 _542_ (
    .A(_148_),
    .B(_222_),
    .C1(_219_),
    .C2(_138_),
    .ZN(_013_)
  );
  OAI21_X1 _543_ (
    .A(_147_),
    .B1(_221_),
    .B2(stuck_cnt_r[16]),
    .ZN(_223_)
  );
  AOI21_X1 _544_ (
    .A(_223_),
    .B1(_221_),
    .B2(stuck_cnt_r[16]),
    .ZN(_014_)
  );
  OAI21_X1 _545_ (
    .A(_147_),
    .B1(_219_),
    .B2(stuck_cnt_r[15]),
    .ZN(_224_)
  );
  NOR2_X1 _546_ (
    .A1(_221_),
    .A2(_224_),
    .ZN(_015_)
  );
  AOI21_X1 _547_ (
    .A(stuck_cnt_r[14]),
    .B1(_217_),
    .B2(stuck_cnt_r[13]),
    .ZN(_225_)
  );
  NOR3_X1 _548_ (
    .A1(_148_),
    .A2(_219_),
    .A3(_225_),
    .ZN(_016_)
  );
  OAI21_X1 _549_ (
    .A(_147_),
    .B1(_217_),
    .B2(stuck_cnt_r[13]),
    .ZN(_226_)
  );
  AOI21_X1 _550_ (
    .A(_226_),
    .B1(_217_),
    .B2(stuck_cnt_r[13]),
    .ZN(_017_)
  );
  AOI21_X1 _551_ (
    .A(stuck_cnt_r[12]),
    .B1(_214_),
    .B2(stuck_cnt_r[11]),
    .ZN(_227_)
  );
  NOR3_X1 _552_ (
    .A1(_148_),
    .A2(_217_),
    .A3(_227_),
    .ZN(_018_)
  );
  OAI21_X1 _553_ (
    .A(_147_),
    .B1(_214_),
    .B2(stuck_cnt_r[11]),
    .ZN(_228_)
  );
  AOI21_X1 _554_ (
    .A(_228_),
    .B1(_214_),
    .B2(stuck_cnt_r[11]),
    .ZN(_019_)
  );
  AOI211_X1 _555_ (
    .A(_086_),
    .B(_087_),
    .C1(_147_),
    .C2(_200_),
    .ZN(_229_)
  );
  AOI21_X1 _556_ (
    .A(_210_),
    .B1(_200_),
    .B2(_147_),
    .ZN(_230_)
  );
  AND3_X1 _557_ (
    .A1(stuck_cnt_r[9]),
    .A2(_202_),
    .A3(_211_),
    .ZN(_231_)
  );
  NAND3_X1 _558_ (
    .A1(stuck_cnt_r[9]),
    .A2(_202_),
    .A3(_211_),
    .ZN(_232_)
  );
  AOI211_X1 _559_ (
    .A(_148_),
    .B(_214_),
    .C1(_232_),
    .C2(_084_),
    .ZN(_020_)
  );
  AOI21_X1 _560_ (
    .A(stuck_cnt_r[9]),
    .B1(_202_),
    .B2(_211_),
    .ZN(_233_)
  );
  NOR3_X1 _561_ (
    .A1(_148_),
    .A2(_231_),
    .A3(_233_),
    .ZN(_021_)
  );
  AOI21_X1 _562_ (
    .A(stuck_cnt_r[8]),
    .B1(_230_),
    .B2(stuck_cnt_r[7]),
    .ZN(_234_)
  );
  AOI211_X1 _563_ (
    .A(_148_),
    .B(_234_),
    .C1(_211_),
    .C2(_202_),
    .ZN(_022_)
  );
  OAI21_X1 _564_ (
    .A(_147_),
    .B1(_230_),
    .B2(stuck_cnt_r[7]),
    .ZN(_235_)
  );
  AOI21_X1 _565_ (
    .A(_235_),
    .B1(_230_),
    .B2(stuck_cnt_r[7]),
    .ZN(_023_)
  );
  AND3_X1 _566_ (
    .A1(stuck_cnt_r[5]),
    .A2(_202_),
    .A3(_209_),
    .ZN(_236_)
  );
  NAND3_X1 _567_ (
    .A1(stuck_cnt_r[5]),
    .A2(_202_),
    .A3(_209_),
    .ZN(_237_)
  );
  AOI211_X1 _568_ (
    .A(_148_),
    .B(_230_),
    .C1(_237_),
    .C2(_081_),
    .ZN(_024_)
  );
  AOI21_X1 _569_ (
    .A(stuck_cnt_r[5]),
    .B1(_202_),
    .B2(_209_),
    .ZN(_238_)
  );
  NOR3_X1 _570_ (
    .A1(_148_),
    .A2(_236_),
    .A3(_238_),
    .ZN(_025_)
  );
  AOI21_X1 _571_ (
    .A(stuck_cnt_r[4]),
    .B1(_202_),
    .B2(_207_),
    .ZN(_239_)
  );
  AOI211_X1 _572_ (
    .A(_148_),
    .B(_239_),
    .C1(_209_),
    .C2(_202_),
    .ZN(_026_)
  );
  AOI21_X1 _573_ (
    .A(stuck_cnt_r[3]),
    .B1(_229_),
    .B2(stuck_cnt_r[2]),
    .ZN(_240_)
  );
  AOI211_X1 _574_ (
    .A(_148_),
    .B(_240_),
    .C1(_207_),
    .C2(_202_),
    .ZN(_027_)
  );
  OAI21_X1 _575_ (
    .A(_147_),
    .B1(_229_),
    .B2(stuck_cnt_r[2]),
    .ZN(_241_)
  );
  AOI21_X1 _576_ (
    .A(_241_),
    .B1(_229_),
    .B2(stuck_cnt_r[2]),
    .ZN(_028_)
  );
  AOI21_X1 _577_ (
    .A(stuck_cnt_r[1]),
    .B1(stuck_cnt_r[0]),
    .B2(_202_),
    .ZN(_242_)
  );
  NOR3_X1 _578_ (
    .A1(_148_),
    .A2(_229_),
    .A3(_242_),
    .ZN(_029_)
  );
  AOI21_X1 _579_ (
    .A(stuck_cnt_r[0]),
    .B1(_147_),
    .B2(_201_),
    .ZN(_243_)
  );
  AOI21_X1 _580_ (
    .A(_243_),
    .B1(_202_),
    .B2(stuck_cnt_r[0]),
    .ZN(_030_)
  );
  NOR3_X1 _581_ (
    .A1(_097_),
    .A2(lwr_addr_r[3]),
    .A3(lwr_addr_r[1]),
    .ZN(_244_)
  );
  NOR3_X1 _582_ (
    .A1(lwr_addr_r[11]),
    .A2(lwr_addr_r[8]),
    .A3(_101_),
    .ZN(_245_)
  );
  NOR3_X1 _583_ (
    .A1(lwr_addr_r[10]),
    .A2(lwr_addr_r[9]),
    .A3(_132_),
    .ZN(_246_)
  );
  NOR3_X1 _584_ (
    .A1(_098_),
    .A2(_099_),
    .A3(lwr_addr_r[0]),
    .ZN(_247_)
  );
  NAND4_X1 _585_ (
    .A1(_244_),
    .A2(_245_),
    .A3(_246_),
    .A4(_247_),
    .ZN(_248_)
  );
  NOR2_X1 _586_ (
    .A1(lwr_addr_r[2]),
    .A2(_248_),
    .ZN(_249_)
  );
  INV_X1 _587_ (
    .A(_249_),
    .ZN(_250_)
  );
  NOR3_X1 _588_ (
    .A1(s_wdata[8]),
    .A2(s_wdata[9]),
    .A3(_250_),
    .ZN(_251_)
  );
  MUX2_X1 _589_ (
    .A(\whitelist_addr[0] [5]),
    .B(s_wdata[5]),
    .S(_251_),
    .Z(_031_)
  );
  MUX2_X1 _590_ (
    .A(\whitelist_addr[0] [4]),
    .B(s_wdata[4]),
    .S(_251_),
    .Z(_032_)
  );
  MUX2_X1 _591_ (
    .A(\whitelist_addr[0] [3]),
    .B(s_wdata[3]),
    .S(_251_),
    .Z(_033_)
  );
  AND3_X1 _592_ (
    .A1(_103_),
    .A2(s_wdata[9]),
    .A3(_249_),
    .ZN(_252_)
  );
  MUX2_X1 _593_ (
    .A(\whitelist_addr[2] [5]),
    .B(s_wdata[5]),
    .S(_252_),
    .Z(_034_)
  );
  MUX2_X1 _594_ (
    .A(\whitelist_addr[2] [4]),
    .B(s_wdata[4]),
    .S(_252_),
    .Z(_035_)
  );
  MUX2_X1 _595_ (
    .A(\whitelist_addr[2] [3]),
    .B(s_wdata[3]),
    .S(_252_),
    .Z(_036_)
  );
  NAND3_X1 _596_ (
    .A1(s_wdata[8]),
    .A2(s_wdata[9]),
    .A3(_249_),
    .ZN(_253_)
  );
  MUX2_X1 _597_ (
    .A(s_wdata[6]),
    .B(\whitelist_addr[3] [6]),
    .S(_253_),
    .Z(_037_)
  );
  MUX2_X1 _598_ (
    .A(\whitelist_addr[2] [2]),
    .B(s_wdata[2]),
    .S(_252_),
    .Z(_038_)
  );
  MUX2_X1 _599_ (
    .A(\whitelist_addr[2] [1]),
    .B(s_wdata[1]),
    .S(_252_),
    .Z(_039_)
  );
  NAND2_X1 _600_ (
    .A1(lrd_rdata_r[0]),
    .A2(_137_),
    .ZN(_254_)
  );
  NAND2_X1 _601_ (
    .A1(whitelist_en),
    .A2(_204_),
    .ZN(_255_)
  );
  OAI21_X1 _602_ (
    .A(_254_),
    .B1(_255_),
    .B2(_137_),
    .ZN(_040_)
  );
  MUX2_X1 _603_ (
    .A(\whitelist_addr[2] [0]),
    .B(s_wdata[0]),
    .S(_252_),
    .Z(_041_)
  );
  MUX2_X1 _604_ (
    .A(\whitelist_addr[0] [2]),
    .B(s_wdata[2]),
    .S(_251_),
    .Z(_042_)
  );
  MUX2_X1 _605_ (
    .A(s_wdata[5]),
    .B(\whitelist_addr[3] [5]),
    .S(_253_),
    .Z(_043_)
  );
  MUX2_X1 _606_ (
    .A(s_wdata[4]),
    .B(\whitelist_addr[3] [4]),
    .S(_253_),
    .Z(_044_)
  );
  MUX2_X1 _607_ (
    .A(\whitelist_addr[2] [6]),
    .B(s_wdata[6]),
    .S(_252_),
    .Z(_045_)
  );
  MUX2_X1 _608_ (
    .A(s_wdata[3]),
    .B(\whitelist_addr[3] [3]),
    .S(_253_),
    .Z(_046_)
  );
  MUX2_X1 _609_ (
    .A(s_wdata[2]),
    .B(\whitelist_addr[3] [2]),
    .S(_253_),
    .Z(_047_)
  );
  MUX2_X1 _610_ (
    .A(s_wdata[1]),
    .B(\whitelist_addr[3] [1]),
    .S(_253_),
    .Z(_048_)
  );
  MUX2_X1 _611_ (
    .A(s_wdata[0]),
    .B(\whitelist_addr[3] [0]),
    .S(_253_),
    .Z(_049_)
  );
  MUX2_X1 _612_ (
    .A(\whitelist_addr[0] [1]),
    .B(s_wdata[1]),
    .S(_251_),
    .Z(_050_)
  );
  NOR3_X1 _613_ (
    .A1(_103_),
    .A2(s_wdata[9]),
    .A3(_250_),
    .ZN(_256_)
  );
  MUX2_X1 _614_ (
    .A(\whitelist_addr[1] [6]),
    .B(s_wdata[6]),
    .S(_256_),
    .Z(_051_)
  );
  AND2_X1 _615_ (
    .A1(lwr_addr_r[11]),
    .A2(_155_),
    .ZN(_052_)
  );
  MUX2_X1 _616_ (
    .A(apb_pwdata[5]),
    .B(captured_i2c_addr[5]),
    .S(_196_),
    .Z(_053_)
  );
  MUX2_X1 _617_ (
    .A(apb_pwdata[4]),
    .B(captured_i2c_addr[4]),
    .S(_196_),
    .Z(_054_)
  );
  MUX2_X1 _618_ (
    .A(apb_pwdata[6]),
    .B(captured_i2c_addr[6]),
    .S(_196_),
    .Z(_055_)
  );
  MUX2_X1 _619_ (
    .A(apb_pwdata[3]),
    .B(captured_i2c_addr[3]),
    .S(_196_),
    .Z(_056_)
  );
  MUX2_X1 _620_ (
    .A(apb_pwdata[2]),
    .B(captured_i2c_addr[2]),
    .S(_196_),
    .Z(_057_)
  );
  MUX2_X1 _621_ (
    .A(apb_pwdata[1]),
    .B(captured_i2c_addr[1]),
    .S(_196_),
    .Z(_058_)
  );
  MUX2_X1 _622_ (
    .A(apb_pwdata[0]),
    .B(captured_i2c_addr[0]),
    .S(_196_),
    .Z(_059_)
  );
  AND2_X1 _623_ (
    .A1(lwr_addr_r[10]),
    .A2(_155_),
    .ZN(_060_)
  );
  AND2_X1 _624_ (
    .A1(lwr_addr_r[9]),
    .A2(_155_),
    .ZN(_061_)
  );
  NOR2_X1 _625_ (
    .A1(_102_),
    .A2(_248_),
    .ZN(_257_)
  );
  MUX2_X1 _626_ (
    .A(whitelist_en),
    .B(s_wdata[0]),
    .S(_257_),
    .Z(_062_)
  );
  AND2_X1 _627_ (
    .A1(lwr_addr_r[8]),
    .A2(_155_),
    .ZN(_063_)
  );
  NAND2_X1 _628_ (
    .A1(_101_),
    .A2(_155_),
    .ZN(_064_)
  );
  NAND2_X1 _629_ (
    .A1(_097_),
    .A2(_155_),
    .ZN(_065_)
  );
  NAND2_X1 _630_ (
    .A1(_098_),
    .A2(_155_),
    .ZN(_066_)
  );
  NAND2_X1 _631_ (
    .A1(_099_),
    .A2(_155_),
    .ZN(_067_)
  );
  AOI21_X1 _632_ (
    .A(_100_),
    .B1(lwr_state_r[0]),
    .B2(_154_),
    .ZN(_068_)
  );
  MUX2_X1 _633_ (
    .A(s_awaddr[2]),
    .B(lwr_addr_r[2]),
    .S(_155_),
    .Z(_069_)
  );
  AND2_X1 _634_ (
    .A1(lwr_addr_r[1]),
    .A2(_155_),
    .ZN(_070_)
  );
  AND2_X1 _635_ (
    .A1(lwr_addr_r[0]),
    .A2(_155_),
    .ZN(_071_)
  );
  MUX2_X1 _636_ (
    .A(\whitelist_addr[1] [5]),
    .B(s_wdata[5]),
    .S(_256_),
    .Z(_072_)
  );
  MUX2_X1 _637_ (
    .A(\whitelist_addr[1] [4]),
    .B(s_wdata[4]),
    .S(_256_),
    .Z(_073_)
  );
  MUX2_X1 _638_ (
    .A(\whitelist_addr[1] [3]),
    .B(s_wdata[3]),
    .S(_256_),
    .Z(_074_)
  );
  MUX2_X1 _639_ (
    .A(\whitelist_addr[1] [2]),
    .B(s_wdata[2]),
    .S(_256_),
    .Z(_075_)
  );
  MUX2_X1 _640_ (
    .A(\whitelist_addr[1] [1]),
    .B(s_wdata[1]),
    .S(_256_),
    .Z(_076_)
  );
  MUX2_X1 _641_ (
    .A(\whitelist_addr[1] [0]),
    .B(s_wdata[0]),
    .S(_256_),
    .Z(_077_)
  );
  AND2_X1 _642_ (
    .A1(stuck_cnt_r[23]),
    .A2(_147_),
    .ZN(_078_)
  );
  MUX2_X1 _643_ (
    .A(\whitelist_addr[0] [0]),
    .B(s_wdata[0]),
    .S(_251_),
    .Z(_079_)
  );
  MUX2_X1 _644_ (
    .A(\whitelist_addr[0] [6]),
    .B(s_wdata[6]),
    .S(_251_),
    .Z(_080_)
  );
  DFFR_X1 _645_ (
    .CK(clk),
    .D(_040_),
    .Q(lrd_rdata_r[0]),
    .QN(_298_),
    .RN(rst_n)
  );
  DFFR_X1 _646_ (
    .CK(clk),
    .D(_010_),
    .Q(lrd_rdata_r[1]),
    .QN(_328_),
    .RN(rst_n)
  );
  DFFR_X1 _647_ (
    .CK(clk),
    .D(_077_),
    .Q(\whitelist_addr[1] [0]),
    .QN(_261_),
    .RN(rst_n)
  );
  DFFR_X1 _648_ (
    .CK(clk),
    .D(_076_),
    .Q(\whitelist_addr[1] [1]),
    .QN(_338_),
    .RN(rst_n)
  );
  DFFR_X1 _649_ (
    .CK(clk),
    .D(_075_),
    .Q(\whitelist_addr[1] [2]),
    .QN(_263_),
    .RN(rst_n)
  );
  DFFR_X1 _650_ (
    .CK(clk),
    .D(_074_),
    .Q(\whitelist_addr[1] [3]),
    .QN(_264_),
    .RN(rst_n)
  );
  DFFR_X1 _651_ (
    .CK(clk),
    .D(_073_),
    .Q(\whitelist_addr[1] [4]),
    .QN(_265_),
    .RN(rst_n)
  );
  DFFR_X1 _652_ (
    .CK(clk),
    .D(_072_),
    .Q(\whitelist_addr[1] [5]),
    .QN(_266_),
    .RN(rst_n)
  );
  DFFR_X1 _653_ (
    .CK(clk),
    .D(_051_),
    .Q(\whitelist_addr[1] [6]),
    .QN(_287_),
    .RN(rst_n)
  );
  DFFR_X1 _654_ (
    .CK(clk),
    .D(_071_),
    .Q(lwr_addr_r[0]),
    .QN(_267_),
    .RN(rst_n)
  );
  DFFR_X1 _655_ (
    .CK(clk),
    .D(_070_),
    .Q(lwr_addr_r[1]),
    .QN(_337_),
    .RN(rst_n)
  );
  DFFR_X1 _656_ (
    .CK(clk),
    .D(_069_),
    .Q(lwr_addr_r[2]),
    .QN(_269_),
    .RN(rst_n)
  );
  DFFR_X1 _657_ (
    .CK(clk),
    .D(_068_),
    .Q(lwr_addr_r[3]),
    .QN(_270_),
    .RN(rst_n)
  );
  DFFR_X1 _658_ (
    .CK(clk),
    .D(_067_),
    .Q(lwr_addr_r[4]),
    .QN(_271_),
    .RN(rst_n)
  );
  DFFR_X1 _659_ (
    .CK(clk),
    .D(_066_),
    .Q(lwr_addr_r[5]),
    .QN(_272_),
    .RN(rst_n)
  );
  DFFR_X1 _660_ (
    .CK(clk),
    .D(_065_),
    .Q(lwr_addr_r[6]),
    .QN(_273_),
    .RN(rst_n)
  );
  DFFR_X1 _661_ (
    .CK(clk),
    .D(_064_),
    .Q(lwr_addr_r[7]),
    .QN(_274_),
    .RN(rst_n)
  );
  DFFR_X1 _662_ (
    .CK(clk),
    .D(_063_),
    .Q(lwr_addr_r[8]),
    .QN(_275_),
    .RN(rst_n)
  );
  DFFR_X1 _663_ (
    .CK(clk),
    .D(_061_),
    .Q(lwr_addr_r[9]),
    .QN(_277_),
    .RN(rst_n)
  );
  DFFR_X1 _664_ (
    .CK(clk),
    .D(_060_),
    .Q(lwr_addr_r[10]),
    .QN(_278_),
    .RN(rst_n)
  );
  DFFR_X1 _665_ (
    .CK(clk),
    .D(_052_),
    .Q(lwr_addr_r[11]),
    .QN(_286_),
    .RN(rst_n)
  );
  DFFR_X1 _666_ (
    .CK(clk),
    .D(_059_),
    .Q(captured_i2c_addr[0]),
    .QN(_279_),
    .RN(rst_n)
  );
  DFFR_X1 _667_ (
    .CK(clk),
    .D(_058_),
    .Q(captured_i2c_addr[1]),
    .QN(_280_),
    .RN(rst_n)
  );
  DFFR_X1 _668_ (
    .CK(clk),
    .D(_057_),
    .Q(captured_i2c_addr[2]),
    .QN(_281_),
    .RN(rst_n)
  );
  DFFR_X1 _669_ (
    .CK(clk),
    .D(_056_),
    .Q(captured_i2c_addr[3]),
    .QN(_282_),
    .RN(rst_n)
  );
  DFFR_X1 _670_ (
    .CK(clk),
    .D(_054_),
    .Q(captured_i2c_addr[4]),
    .QN(_284_),
    .RN(rst_n)
  );
  DFFR_X1 _671_ (
    .CK(clk),
    .D(_053_),
    .Q(captured_i2c_addr[5]),
    .QN(_336_),
    .RN(rst_n)
  );
  DFFR_X1 _672_ (
    .CK(clk),
    .D(_055_),
    .Q(captured_i2c_addr[6]),
    .QN(_283_),
    .RN(rst_n)
  );
  DFFR_X1 _673_ (
    .CK(clk),
    .D(_049_),
    .Q(\whitelist_addr[3] [0]),
    .QN(_289_),
    .RN(rst_n)
  );
  DFFR_X1 _674_ (
    .CK(clk),
    .D(_048_),
    .Q(\whitelist_addr[3] [1]),
    .QN(_290_),
    .RN(rst_n)
  );
  DFFR_X1 _675_ (
    .CK(clk),
    .D(_047_),
    .Q(\whitelist_addr[3] [2]),
    .QN(_291_),
    .RN(rst_n)
  );
  DFFR_X1 _676_ (
    .CK(clk),
    .D(_046_),
    .Q(\whitelist_addr[3] [3]),
    .QN(_292_),
    .RN(rst_n)
  );
  DFFR_X1 _677_ (
    .CK(clk),
    .D(_044_),
    .Q(\whitelist_addr[3] [4]),
    .QN(_294_),
    .RN(rst_n)
  );
  DFFR_X1 _678_ (
    .CK(clk),
    .D(_043_),
    .Q(\whitelist_addr[3] [5]),
    .QN(_295_),
    .RN(rst_n)
  );
  DFFR_X1 _679_ (
    .CK(clk),
    .D(_037_),
    .Q(\whitelist_addr[3] [6]),
    .QN(_301_),
    .RN(rst_n)
  );
  DFFR_X1 _680_ (
    .CK(clk),
    .D(_041_),
    .Q(\whitelist_addr[2] [0]),
    .QN(_297_),
    .RN(rst_n)
  );
  DFFR_X1 _681_ (
    .CK(clk),
    .D(_039_),
    .Q(\whitelist_addr[2] [1]),
    .QN(_299_),
    .RN(rst_n)
  );
  DFFR_X1 _682_ (
    .CK(clk),
    .D(_038_),
    .Q(\whitelist_addr[2] [2]),
    .QN(_300_),
    .RN(rst_n)
  );
  DFFR_X1 _683_ (
    .CK(clk),
    .D(_036_),
    .Q(\whitelist_addr[2] [3]),
    .QN(_302_),
    .RN(rst_n)
  );
  DFFR_X1 _684_ (
    .CK(clk),
    .D(_035_),
    .Q(\whitelist_addr[2] [4]),
    .QN(_303_),
    .RN(rst_n)
  );
  DFFR_X1 _685_ (
    .CK(clk),
    .D(_034_),
    .Q(\whitelist_addr[2] [5]),
    .QN(_304_),
    .RN(rst_n)
  );
  DFFR_X1 _686_ (
    .CK(clk),
    .D(_045_),
    .Q(\whitelist_addr[2] [6]),
    .QN(_293_),
    .RN(rst_n)
  );
  DFFR_X1 _687_ (
    .CK(clk),
    .D(_062_),
    .Q(whitelist_en),
    .QN(_276_),
    .RN(rst_n)
  );
  DFFR_X1 _688_ (
    .CK(clk),
    .D(_030_),
    .Q(stuck_cnt_r[0]),
    .QN(_333_),
    .RN(rst_n)
  );
  DFFR_X1 _689_ (
    .CK(clk),
    .D(_029_),
    .Q(stuck_cnt_r[1]),
    .QN(_309_),
    .RN(rst_n)
  );
  DFFR_X1 _690_ (
    .CK(clk),
    .D(_028_),
    .Q(stuck_cnt_r[2]),
    .QN(_310_),
    .RN(rst_n)
  );
  DFFR_X1 _691_ (
    .CK(clk),
    .D(_027_),
    .Q(stuck_cnt_r[3]),
    .QN(_311_),
    .RN(rst_n)
  );
  DFFR_X1 _692_ (
    .CK(clk),
    .D(_026_),
    .Q(stuck_cnt_r[4]),
    .QN(_312_),
    .RN(rst_n)
  );
  DFFR_X1 _693_ (
    .CK(clk),
    .D(_025_),
    .Q(stuck_cnt_r[5]),
    .QN(_313_),
    .RN(rst_n)
  );
  DFFR_X1 _694_ (
    .CK(clk),
    .D(_024_),
    .Q(stuck_cnt_r[6]),
    .QN(_314_),
    .RN(rst_n)
  );
  DFFR_X1 _695_ (
    .CK(clk),
    .D(_023_),
    .Q(stuck_cnt_r[7]),
    .QN(_315_),
    .RN(rst_n)
  );
  DFFR_X1 _696_ (
    .CK(clk),
    .D(_022_),
    .Q(stuck_cnt_r[8]),
    .QN(_316_),
    .RN(rst_n)
  );
  DFFR_X1 _697_ (
    .CK(clk),
    .D(_021_),
    .Q(stuck_cnt_r[9]),
    .QN(_317_),
    .RN(rst_n)
  );
  DFFR_X1 _698_ (
    .CK(clk),
    .D(_020_),
    .Q(stuck_cnt_r[10]),
    .QN(_318_),
    .RN(rst_n)
  );
  DFFR_X1 _699_ (
    .CK(clk),
    .D(_019_),
    .Q(stuck_cnt_r[11]),
    .QN(_319_),
    .RN(rst_n)
  );
  DFFR_X1 _700_ (
    .CK(clk),
    .D(_018_),
    .Q(stuck_cnt_r[12]),
    .QN(_320_),
    .RN(rst_n)
  );
  DFFR_X1 _701_ (
    .CK(clk),
    .D(_017_),
    .Q(stuck_cnt_r[13]),
    .QN(_321_),
    .RN(rst_n)
  );
  DFFR_X1 _702_ (
    .CK(clk),
    .D(_016_),
    .Q(stuck_cnt_r[14]),
    .QN(_322_),
    .RN(rst_n)
  );
  DFFR_X1 _703_ (
    .CK(clk),
    .D(_015_),
    .Q(stuck_cnt_r[15]),
    .QN(_323_),
    .RN(rst_n)
  );
  DFFR_X1 _704_ (
    .CK(clk),
    .D(_014_),
    .Q(stuck_cnt_r[16]),
    .QN(_324_),
    .RN(rst_n)
  );
  DFFR_X1 _705_ (
    .CK(clk),
    .D(_013_),
    .Q(stuck_cnt_r[17]),
    .QN(_325_),
    .RN(rst_n)
  );
  DFFR_X1 _706_ (
    .CK(clk),
    .D(_012_),
    .Q(stuck_cnt_r[18]),
    .QN(_326_),
    .RN(rst_n)
  );
  DFFR_X1 _707_ (
    .CK(clk),
    .D(_011_),
    .Q(stuck_cnt_r[19]),
    .QN(_327_),
    .RN(rst_n)
  );
  DFFR_X1 _708_ (
    .CK(clk),
    .D(_009_),
    .Q(stuck_cnt_r[20]),
    .QN(_329_),
    .RN(rst_n)
  );
  DFFR_X1 _709_ (
    .CK(clk),
    .D(_008_),
    .Q(stuck_cnt_r[21]),
    .QN(_330_),
    .RN(rst_n)
  );
  DFFR_X1 _710_ (
    .CK(clk),
    .D(_007_),
    .Q(stuck_cnt_r[22]),
    .QN(_331_),
    .RN(rst_n)
  );
  DFFR_X1 _711_ (
    .CK(clk),
    .D(_078_),
    .Q(stuck_cnt_r[23]),
    .QN(_260_),
    .RN(rst_n)
  );
  DFFR_X1 _712_ (
    .CK(clk),
    .D(_079_),
    .Q(\whitelist_addr[0] [0]),
    .QN(_259_),
    .RN(rst_n)
  );
  DFFR_X1 _713_ (
    .CK(clk),
    .D(_050_),
    .Q(\whitelist_addr[0] [1]),
    .QN(_335_),
    .RN(rst_n)
  );
  DFFR_X1 _714_ (
    .CK(clk),
    .D(_042_),
    .Q(\whitelist_addr[0] [2]),
    .QN(_296_),
    .RN(rst_n)
  );
  DFFR_X1 _715_ (
    .CK(clk),
    .D(_033_),
    .Q(\whitelist_addr[0] [3]),
    .QN(_305_),
    .RN(rst_n)
  );
  DFFR_X1 _716_ (
    .CK(clk),
    .D(_032_),
    .Q(\whitelist_addr[0] [4]),
    .QN(_306_),
    .RN(rst_n)
  );
  DFFR_X1 _717_ (
    .CK(clk),
    .D(_031_),
    .Q(\whitelist_addr[0] [5]),
    .QN(_307_),
    .RN(rst_n)
  );
  DFFR_X1 _718_ (
    .CK(clk),
    .D(_080_),
    .Q(\whitelist_addr[0] [6]),
    .QN(_258_),
    .RN(rst_n)
  );
  DFFS_X1 _719_ (
    .CK(clk),
    .D(_004_),
    .Q(lwr_state_r[0]),
    .QN(_308_),
    .SN(rst_n)
  );
  DFFR_X1 _720_ (
    .CK(clk),
    .D(_005_),
    .Q(lwr_state_r[1]),
    .QN(_334_),
    .RN(rst_n)
  );
  DFFR_X1 _721_ (
    .CK(clk),
    .D(_006_),
    .Q(lwr_state_r[2]),
    .QN(_262_),
    .RN(rst_n)
  );
  DFFS_X1 _722_ (
    .CK(clk),
    .D(_002_),
    .Q(lrd_state_r[0]),
    .QN(_332_),
    .SN(rst_n)
  );
  DFFR_X1 _723_ (
    .CK(clk),
    .D(_003_),
    .Q(lrd_state_r[1]),
    .QN(_288_),
    .RN(rst_n)
  );
  DFFR_X1 _724_ (
    .CK(clk),
    .D(_001_),
    .Q(clr_stuck_r),
    .QN(_268_),
    .RN(rst_n)
  );
  DFFR_X1 _725_ (
    .CK(clk),
    .D(_000_),
    .Q(bus_stuck_r),
    .QN(_285_),
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
  \$paramod\apb_i2c\APB_ADDR_WIDTH=s32'00000000000000000000000000001100  u_i2c (
    .HCLK(clk),
    .HRESETn(rst_n),
    .PADDR(apb_paddr),
    .PENABLE(i2c_penable_gated),
    .PRDATA(apb_prdata),
    .PREADY(i2c_pready_raw),
    .PSEL(i2c_psel_gated),
    .PSLVERR(i2c_pslverr_raw),
    .PWDATA(apb_pwdata),
    .PWRITE(apb_pwrite),
    .interrupt_o(irq),
    .scl_pad_i(i2c_scl),
    .scl_pad_o(i2c_scl),
    .scl_padoen_o(scl_padoen_o),
    .sda_pad_i(i2c_sda),
    .sda_pad_o(i2c_sda),
    .sda_padoen_o(sda_padoen_o)
  );
  assign i2c_prdata_raw = apb_prdata;
  assign lrd_rdata_r[31:2] = 30'h00000000;
  assign clr_stuck = clr_stuck_r;
  assign sda_pad_o = i2c_sda;
  assign sda_pad_i = i2c_sda;
  assign scl_pad_o = i2c_scl;
  assign scl_pad_i = i2c_scl;
endmodule
