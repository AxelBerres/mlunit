function test = test_error_output

test = load_tests_from_mfile(test_loader);

function test_special_characters

    error('This some special characters: !"§$%&/()=?. Enjoy.');

function test_unknown_function

    do_you_know_this();

function test_invalid_usage

    fileparts();

function test_syntax_error_ifend

    sample_syntax_error_ifend();

function test_syntax_error_paren

    sample_syntax_error_paren();
