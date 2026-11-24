<?php

declare(strict_types=1);

namespace Tests;

use App\Greeting;
use PHPUnit\Framework\TestCase;

final class GreetingTest extends TestCase
{
    public function testGreetsANamedPerson(): void
    {
        self::assertSame('Hello, Grace Hopper!', Greeting::forName(' Grace Hopper '));
    }

    public function testUsesTheDefaultForABlankName(): void
    {
        self::assertSame('Hello, world!', Greeting::forName(' '));
    }
}
