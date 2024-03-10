class count_drv;

        virtual count_if.DRV_MP drv_if;

        count_trans data2duv;

        mailbox #(count_trans) gen2drv;

        function new(virtual count_if.DRV_MP drv_if,
                     mailbox #(count_trans) gen2drv);
                this.drv_if = drv_if;
                this.gen2drv = gen2drv;
        endfunction

        virtual task drive();
                @(drv_if.drv_cb);
                drv_if.drv_cb.reset <= data2duv.reset;
                drv_if.drv_cb.data <= data2duv.data;
                drv_if.drv_cb.load <= data2duv.load;
                drv_if.drv_cb.mode <= data2duv.mode;
        endtask

        virtual task start();
                fork
                   forever
                         begin
                        gen2drv.get(data2duv);
                        drive();
                    end
                join_none
        endtask
endclass
