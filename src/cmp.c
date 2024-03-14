
#include <stdio.h>

int
main (int argc, char **argv)
{
  if (argc == 3)
    {
      FILE *f0;
      FILE *f1;
      f0 = fopen (argv[1], "rb");
      if (f0 == NULL)
        return 255;
      f1 = fopen (argv[2], "rb");
      if (f1 == NULL)
        return 255;
      do {
        int c = fgetc (f0);
        int c0;
        if ((c0 = fgetc (f1)) == EOF || c == EOF)
          {
            fclose (f1);
            fclose (f0);
            if (c0 == c)
              return 0;
            else
              return 128;
          }
        if (c0 != c)
          {
            fclose (f1);
            fclose (f0);
            return 255;
          }
      } while (1);
    }
  else
    return 255;
}

