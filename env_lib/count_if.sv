interface count_if(input bit clock);

        logic reset;
        logic mode;
        logic load;
        logic [3:0] data;
        logic [3:0]data_out;

        clocking drv_cb@(posedge clock);
                default input #1 output #1;
                output reset;
                output data;
                output load;
                output mode;
        endclocking

        clocking wr_mon_cb @(posedge clock);
                default input #1 output #1;
                input reset;
                input data;
                input load;
                input mode;
        endclocking

        clocking rd_mon_cb @(posedge clock);
                default input #1 output #1;
                input data_out;
        endclocking

        modport DRV_MP (clocking drv_cb);

        modport WR_MON_MP (clocking wr_mon_cb);

        modport RD_MON_MP (clocking rd_mon_cb);

endinterface
