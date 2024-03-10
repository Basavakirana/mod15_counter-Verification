module top ();

        import count_pkg::*;

        parameter cycle = 10;

        reg clock;

        count_if DUV_IF(clock);

        count_test test_h;

//      count_test_extnd1 ext_test_h1;

        mod15_counter DUT ( .clk                (clock),
                                .rst            (DUV_IF.reset),
                                .mode           (DUV_IF.mode),
                                .load           (DUV_IF.load),
                                .data           (DUV_IF.data),
                                .data_out       (DUV_IF.data_out)
                                );

        initial
             begin
                clock = 1'b0;
                forever #(cycle/2) clock = ~clock;
             end

        initial
            begin

                `ifdef VCS
                 $fsdbDumpvars(0, top);
                 `endif

                if($test$plusargs("TEST1"))
                   begin
                        test_h = new(DUV_IF,DUV_IF,DUV_IF);
                        number_of_transactions = 500;
                        test_h.build();
                        test_h.run();
                        $finish;
                    end

        //        if($test$plusargs("TEST2"))
          //         begin
            //            ext_test_h1 = new(DUV_IF,DUV_IF,DUV_IF);
              //          number_of_transactions = 500;
                //        ext_test_h1.build();
                  //      ext_test_h1.run();
                    //    $finish;
                   // end
            end
endmodule
