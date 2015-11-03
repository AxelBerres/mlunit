function test = test_error_output %#ok<STOUT>

output_tests_from_mfile;

function test_special_characters

    error('This some special characters: !"§$%&/()=?. Enjoy.'); %#ok<CTPCT>

function test_unknown_function

    do_you_know_this();

function test_invalid_usage

    fileparts();

function test_syntax_error_ifend

    sample_syntax_error_ifend();

function test_syntax_error_paren

    sample_syntax_error_paren();
