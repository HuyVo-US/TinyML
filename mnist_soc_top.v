//============================================================================
// mnist_soc_top.v — SoC Top-Level for DE10-Standard
//============================================================================
// Connects the Platform Designer generated Nios II system to board pins.
//
// HEX0 hien thi ket qua predicted digit TRUC TIEP tu phan cung
// (khong can phan mem can thiep) — khi MLP Accelerator tinh xong,
// result_digit tu dong cap nhat va hex_decoder hien thi len HEX0.
//
// LEDR[0] = inference done (result_valid)
// LEDR[9:1] = dieu khien boi Nios II software qua LED PIO
//============================================================================

module mnist_soc_top (
    // Clock & Reset
    input  wire        CLOCK_50,       // 50 MHz clock
    input  wire [3:0]  KEY,            // Push buttons (active-low)

    // Switches
    input  wire [9:0]  SW,

    // LEDs
    output wire [9:0]  LEDR,

    // 7-Segment Displays (active-low)
    output wire [6:0]  HEX0,
    output wire [6:0]  HEX1,
    output wire [6:0]  HEX2,
    output wire [6:0]  HEX3,
    output wire [6:0]  HEX4,
    output wire [6:0]  HEX5
);

    // ========================================================================
    // System Reset
    // ========================================================================
    wire sys_reset_n = KEY[0];

    // ========================================================================
    // MLP Accelerator — Direct Hardware Outputs (conduit exports)
    // ========================================================================
    // Cac tin hieu nay TRUC TIEP tu MLP accelerator hardware,
    // KHONG di qua Nios II software — ket qua tu dong hien thi
    // ngay khi phan cung tinh xong.
    wire [3:0] mlp_result_digit;   // So du doan (0-9)
    wire       mlp_result_valid;   // 1 = da tinh xong

    // ========================================================================
    // Nios II System (Platform Designer Generated)
    // ========================================================================
    // LUU Y: Ten port phai KHOP CHINH XAC voi file system.v
    // duoc Platform Designer generate. Mo file system.v de kiem tra.
    //
    // Kiem tra bang cach tim trong file system.v cac dong:
    //   output wire [3:0]  mlp_result_digit_result_digit,
    //   output wire        mlp_result_valid_result_valid,
    //   output wire [9:0]  led_external_connection_export,

    system Nios_system (
        .clk_clk                              (CLOCK_50),
        .reset_reset_n                        (sys_reset_n),

        // LED PIO — dieu khien boi Nios II software
        .led_external_connection_export       (LEDR),

        // MLP Accelerator conduit — TRUC TIEP tu phan cung
        .mlp_result_digit_result_digit        (mlp_result_digit),
        .mlp_result_valid_result_valid        (mlp_result_valid)
    );

    // ========================================================================
    // 7-Segment Display — TRUC TIEP tu phan cung (khong can software)
    // ========================================================================
    // mlp_result_digit (4-bit) -> hex_decoder -> HEX0
    //
    // Khi MLP Accelerator tinh xong (done_flag=1), result_digit
    // tu dong co gia tri la digit du doan (0-9).
    // hex_decoder chuyen thanh 7-segment pattern va hien thi len HEX0.
    //
    // Vi du: Gui anh so "7" vao -> phan cung tinh -> result_digit = 4'd7
    //        -> hex_decoder hien "7" tren HEX0

    hex_decoder u_hex0 (
        .digit    (mlp_result_digit),
        .segments (HEX0)
    );

    // HEX1-HEX5: tat (all segments off)
    assign HEX1 = 7'b1111111;
    assign HEX2 = 7'b1111111;
    assign HEX3 = 7'b1111111;
    assign HEX4 = 7'b1111111;
    assign HEX5 = 7'b1111111;

endmodule
