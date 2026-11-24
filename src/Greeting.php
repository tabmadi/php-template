<?php

declare(strict_types=1);

namespace App;

final class Greeting
{
    public static function forName(string $name): string
    {
        $name = trim($name);

        if ($name === '') {
            $name = 'world';
        }

        return "Hello, {$name}!";
    }
}
