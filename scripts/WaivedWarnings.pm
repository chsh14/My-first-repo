package WaivedWarnings;

#use diagnostics;
use strict;
#use warnings;

use Exporter; 
our @ISA = qw(Exporter);
our @EXPORT    = qw(@waivedSynID @waivedbyMessage); 
our @EXPORT_OK = ();
our (@waivedSynID,@waivedbyMessage);# Need ths to be declared as Global variable

# From IC-10195
@waivedSynID = qw(MWLIBP-302 MWLIBP-301 MWLIBP-319 MWLIBP-324 TLUP-005 TLUP-004 VER-225 VER-533 ELAB-2029 ELAB-395 TIM-513 TIM-183 UID-445 UID-606 UPF-506 CMD-030 TIM-164 TIM-103 OPT-314 MV-080 MV-229 OPT-997 OPT-996 PWR-662 UPF-400 TEST-120 MV-611 MV-614 OPT-109 MV-603 MV-616 MV-046 MV-046 MV-039 OPT-1413 PWR-428 UPF-140 OPT-1241 UID-95 UCN-4 TIM-179 TIM-178 TESTXG-56 OPT-1434 OPT-805 PSYN-069 PSYN-442 OPT-1404 TESTXG-53 TEST-451TEST-115 C3-1 C5-1 C6-1 C8-1 C9-1 C12-1 C16-1 C24-1 S19-1 S28-1 X1-1 Z2-1 TEST-504 TEST-505);

#@waivedbyMessage = ();




push (@waivedbyMessage,"Warning: Cell u_LodeRunner/u_TIEHI_Wrapper (TIEHI_Wrapper_1) is unknown (black box) because functionality for output pin Z is bad or incomplete. (TEST-451)");
push (@waivedbyMessage,"Warning: The following input ports have no clock_relative delay specified, a default clock is assumed for these input ports. (TIM-208)");
push (@waivedbyMessage,"Warning: The pin direction of 'ACK_0V9' pin on 'P_SW3V_LOW_R_I2' cell in the 'ICE55N_I2_1V0_1V62SS-40C' technology library is inconsistent with the same-name pin in the '/n/library/nvlsi/tsmc/tsmc55nlp/ICE55N_I2/2.1/milkyway/20150921' physical library. No physical link for the logical lib cell. (PSYN-058)");
push (@waivedbyMessage,"Warning: The pin direction of 'ARST_N_3V6' pin on 'P_SW3V_LOW_R_I2' cell in the 'ICE55N_I2_1V0_1V62SS-40C' technology library is inconsistent with the same-name pin in the '/n/library/nvlsi/tsmc/tsmc55nlp/ICE55N_I2/2.1/milkyway/20150921' physical library. No physical link for the logical lib cell. (PSYN-058)
");
push (@waivedbyMessage,"Warning: The pin direction of 'REQ_0V9' pin on 'P_SW3V_LOW_R_I2' cell in the 'ICE55N_I2_1V0_1V62SS-40C' technology library is inconsistent with the same-name pin in the '/n/library/nvlsi/tsmc/tsmc55nlp/ICE55N_I2/2.1/milkyway/20150921' physical library. No physical link for the logical lib cell. (PSYN-058)
");
push (@waivedbyMessage,"Warning: The pin direction of 'RETAIN_0V9' pin on 'P_SW3V_LOW_R_I2' cell in the 'ICE55N_I2_1V0_1V62SS-40C' technology library is inconsistent with the same-name pin in the '/n/library/nvlsi/tsmc/tsmc55nlp/ICE55N_I2/2.1/milkyway/20150921' physical library. No physical link for the logical lib cell. (PSYN-058)
");
push (@waivedbyMessage,"Warning: Three-state net u_LodeRunner/GPIO15 is not properly driven. (TEST-115)");
push (@waivedbyMessage,"Warning: Verilog 'assign' or 'tran' statements are written out. (VO-4)");
push (@waivedbyMessage,"Warning: Violations occurred during test design rule checking. (TEST-124)");
