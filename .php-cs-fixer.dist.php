<?php

$finder = PhpCsFixer\Finder::create()
    ->files()
    ->name('*.page')
    ->in(__DIR__)
;

$config = new PhpCsFixer\Config();
return $config
    ->setRiskyAllowed(true)
    ->setRules([
        '@PSR12' => true,
        'no_empty_comment' => true,
        'multiline_comment_opening_closing' => true,
        'single_line_comment_spacing' => true,
        'single_line_comment_style' => true,
        'heredoc_indentation' => true,
        'include' => true,
        'no_alternative_syntax' => true,
        'single_space_around_construct' => true,
        'binary_operator_spaces' => ['default' => 'align_single_space_minimal'],
        'concat_space' => ['spacing' => 'one'],
        'linebreak_after_opening_tag' => true,
        'increment_style' => ['style' => 'post'],
        'logical_operators' => true,
        'no_useless_concat_operator' => ['juggle_simple_strings' => true],
        'not_operator_with_space' => true,
        'object_operator_without_whitespace' => true,
        'standardize_increment' => true,
        'standardize_not_equals' => true,
        'no_useless_return' => true,
        'no_empty_statement' => true,
        'semicolon_after_instruction' => true,
        'explicit_string_variable' => true,
        'simple_to_complex_string_variable' => true,
        'method_chaining_indentation' => true,
        'no_extra_blank_lines' => ['tokens' => ['attribute', 'break', 'case', 'continue', 'curly_brace_block', 'default', 'extra', 'parenthesis_brace_block', 'return', 'square_brace_block', 'switch', 'throw', 'use']],
    ])
    ->setIndent('    ')
    ->setLineEnding("\n")
    ->setFinder($finder)
;
