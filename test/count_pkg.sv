package count_pkg;

        int number_of_transactions = 1;

                `include "count_trans.sv"
                `include "count_gen.sv"
                `include "count_drv.sv"
                `include "count_wr_mon.sv"
                `include "count_rd_mon.sv"
                `include "count_model.sv"
                `include "count_sb.sv"
                `include "count_env.sv"
                `include "count_test.sv"

endpackage
