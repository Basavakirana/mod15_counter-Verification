class count_env;

        virtual count_if.DRV_MP drv_if;
        virtual count_if.WR_MON_MP wr_mon_if;
        virtual count_if.RD_MON_MP rd_mon_if;

        mailbox #(count_trans) gen2drv = new();
        mailbox #(count_trans) wrmon2rm = new();
         mailbox #(count_trans) rdmon2sb = new();
         mailbox #(count_trans) rm2sb = new();

        count_gen       gen_h;
        count_drv       driver_h;
        count_wr_mon    wr_mon_h;
        count_rd_mon    rd_mon_h;
        count_model     model_h;
        count_sb        sb_h;

        function new(virtual count_if.DRV_MP drv_if,
                     virtual count_if.WR_MON_MP wr_mon_if,
                     virtual count_if.RD_MON_MP rd_mon_if);
                this.drv_if = drv_if;
                this.wr_mon_if = wr_mon_if;
                this.rd_mon_if = rd_mon_if;
        endfunction

        virtual task build;
                gen_h = new(gen2drv);
                driver_h = new(drv_if,gen2drv);
                wr_mon_h = new(wr_mon_if,wrmon2rm);
                rd_mon_h = new(rd_mon_if,rdmon2sb);
                model_h = new(wrmon2rm,rm2sb);
                sb_h = new(rm2sb,rdmon2sb);
        endtask

        virtual task reset_dut();
                @(drv_if.drv_cb);
                        drv_if.drv_cb.reset <= 1'b1;
                repeat(2)
                      @(drv_if.drv_cb);
                        drv_if.drv_cb.reset <= 1'b0;
        endtask

        virtual task start();
                gen_h.start();
                driver_h.start();
                wr_mon_h.start();
                rd_mon_h.start();
                model_h.start();
                sb_h.start();
        endtask

        virtual task stop();
                wait(sb_h.DONE.triggered);
        endtask

        virtual task run();
                reset_dut();
                start();
                stop();
                sb_h.report();
        endtask
endclass
