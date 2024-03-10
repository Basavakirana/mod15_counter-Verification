/*class count_trans_extnd1 extends count_trans;
        constraint cdata1 {data inside {[1:4],[5:9],[10:14]};}
endclass   */

class count_test;

        virtual count_if.DRV_MP drv_if;
        virtual count_if.WR_MON_MP wr_mon_if;
        virtual count_if.RD_MON_MP rd_mon_if;

        count_env env_h;

        function new(virtual count_if.DRV_MP drv_if,
                     virtual count_if.WR_MON_MP wr_mon_if,
                     virtual count_if.RD_MON_MP rd_mon_if);
                this.drv_if = drv_if;
                this.wr_mon_if = wr_mon_if;
                this.rd_mon_if = rd_mon_if;
                env_h = new (drv_if,wr_mon_if,rd_mon_if);
        endfunction

        virtual task build();
//              number_of_transacions = 500;
                env_h.build();
        endtask

        virtual task run();
                env_h.run();
        endtask

endclass

/*class count_test_extnd1 extends count_test;

        count_trans_extnd1 data_h1;

           function new(virtual count_if.DRV_MP drv_if,
                     virtual count_if.WR_MON_MP wr_mon_if,
                     virtual count_if.RD_MON_MP rd_mon_if);
                super.new(drv_if,wr_mon_if,rd_mon_if);
           endfunction

          virtual task build();
//              number_of_transacions = 500;
                super.build();
        endtask

        virtual task run();
                data_h1 = new();
                env_h.gen_h.trans_h=data_h1;
                super.run();
        endtask
endclass    */
