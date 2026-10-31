`ifndef APB_ASSIGN_SVH_
`define APB_ASSIGN_SVH_

`define APB_ASSIGN(dst, src)         \
  assign dst.paddr   = src.paddr;    \
  assign dst.pprot   = src.pprot;    \
  assign dst.psel    = src.psel;     \
  assign dst.penable = src.penable;  \
  assign dst.pwrite  = src.pwrite;   \
  assign dst.pwdata  = src.pwdata;   \
  assign dst.pstrb   = src.pstrb;    \
  assign src.pready  = dst.pready;   \
  assign src.prdata  = dst.prdata;   \
  assign src.pslverr = dst.pslverr;

`define APB_FROM_REQ(opt_as, apb_if, req_struct) \
  opt_as apb_if.paddr   = req_struct.paddr;      \
  opt_as apb_if.pprot   = req_struct.pprot;      \
  opt_as apb_if.psel    = req_struct.psel;       \
  opt_as apb_if.penable = req_struct.penable;    \
  opt_as apb_if.pwrite  = req_struct.pwrite;     \
  opt_as apb_if.pwdata  = req_struct.pwdata;     \
  opt_as apb_if.pstrb   = req_struct.pstrb;
`define APB_FROM_RESP(opt_as, apb_if, resp_struct) \
  opt_as apb_if.pready  = resp_struct.pready;      \
  opt_as apb_if.prdata  = resp_struct.prdata;      \
  opt_as apb_if.pslverr = resp_struct.pslverr;

`define APB_SET_FROM_REQ(apb_if, req_struct)  `APB_FROM_REQ(, apb_if, req_struct)
`define APB_SET_FROM_RESP(apb_if, resp_struct) `APB_FROM_RESP(, apb_if, resp_struct)

`define APB_ASSIGN_FROM_REQ(apb_if, req_struct)  `APB_FROM_REQ(assign, apb_if, req_struct)
`define APB_ASSIGN_FROM_RESP(apb_if, resp_struct) `APB_FROM_RESP(assign, apb_if, resp_struct)

`define APB_TO_REQ(opt_as, req_struct, apb_if) \
  opt_as req_struct = '{                       \
    paddr:   apb_if.paddr,                     \
    pprot:   apb_if.pprot,                     \
    psel:    apb_if.psel,                      \
    penable: apb_if.penable,                   \
    pwrite:  apb_if.pwrite,                    \
    pwdata:  apb_if.pwdata,                    \
    pstrb:   apb_if.pstrb                      \
  };
`define APB_TO_RESP(opt_as, resp_struct, apb_if) \
  opt_as resp_struct = '{                        \
    pready:  apb_if.pready,                      \
    prdata:  apb_if.prdata,                      \
    pslverr: apb_if.pslverr                      \
  };

`define APB_SET_TO_REQ(req_struct, apb_if)   `APB_TO_REQ(, req_struct, apb_if)
`define APB_SET_TO_RESP(resp_struct, apb_if) `APB_TO_RESP(, resp_struct, apb_if)

`define APB_ASSIGN_TO_REQ(req_struct, apb_if)   `APB_TO_REQ(assign, req_struct, apb_if)
`define APB_ASSIGN_TO_RESP(resp_struct, apb_if) `APB_TO_RESP(assign, resp_struct, apb_if)

`endif
