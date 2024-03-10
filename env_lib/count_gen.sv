class count_gen;

        count_trans trans_h;
        count_trans data2send;

        mailbox #(count_trans) gen2drv;

        function new(mailbox #(count_trans) gen2drv);
                this.gen2drv = gen2drv;
                this.trans_h = new();
        endfunction

        virtual task start();
                fork
                    begin
                        for(int i=0; i<number_of_transactions; i++)
                           begin
                                trans_h.trans_id++;
                                assert(trans_h.randomize());
                                data2send = new trans_h;
                                gen2drv.put(data2send);
                            end
                    end
                join
        endtask
endclass
