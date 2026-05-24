yield - produce values unchanged
================================

Synopsis
--------

.. synopsis::

    yield [VALUES ...]

Description
-----------

``yield`` outputs its arguments unchanged and always returns 0. It is an identity function for use in return position: ``(yield $var)`` produces exactly the values of *var* without side effects.

This is useful as a substitute for ``echo`` or ``printf`` when returning values from a function:

- No status leakage — ``yield`` always succeeds, so ``$status`` is 0 afterward regardless of what the previous command returned.
- No splitting surprises — values pass through ``string collect``, preserving list structure and preventing newline-based splitting in command substitutions.

With no arguments, ``yield`` produces no output and returns 0.

``yield`` does not accept any options, not even ``-h`` or ``--help``.

Example
-------

Return values from a function while preserving element boundaries, even when values contain newlines::

    function myxargs
        while read line
            yield "$($argv (commandline -x --input=$line))"
        end
    end
    count (seq 10 | myxargs printf '(\n%s\n)\n')
    # 10

See Also
--------

- the :doc:`string collect <string-collect>` subcommand, which ``yield`` wraps
- :ref:`Command substitution <expand-command-substitution>` in the language reference
