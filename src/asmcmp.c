#include <stdio.h>
#include <stdlib.h>

FILE *infp;
FILE *outfp;

int max_type;

typedef struct func
{
  struct func *same;
  char *head;
  char *label;
  char *body;
} FUNC;

FUNC *samefnc[256];
FUNC *last_no_out;
char *endlabel;

char inbuffer[32768];

char *
skip_comment_line ()
{
  int c,count;
  char *buf;
  count = 0;
  c = fgetc (infp);
  while (c == '*' || c == '\t' || c == ' ')
    {
      inbuffer[count ++] = c;
      while (c != '\n')
        {
          c = fgetc (infp);
          inbuffer[count ++] = c;
        }
      c = fgetc (infp);
    }
  inbuffer[count] = 0;
  ungetc (c, infp);
  buf = malloc (count);
  strcpy (buf, inbuffer);
  return buf;
}

FUNC*
get_one_func()
{
  int c;
  int count = 0;
  char *pos;
  FUNC *ret = malloc (sizeof (FUNC));
  ret-> same =0;
  ret-> label = 0;
  ret-> body = 0;
  ret-> head = skip_comment_line ();
  /* get label */
  do {
    c = fgetc (infp);
    inbuffer[count ++] = c;
  } while (c != ':');
  inbuffer[count++] = 0;
  ret -> label = malloc (count);
  strcpy (ret->label, inbuffer);

  if (!strcmp (endlabel, inbuffer))
    {
      last_no_out = ret;
      return 0;
    }

  count = 0;

  for (;;)
    {
      char *now;
      do {
        c = fgetc (infp);
        inbuffer[count ++] = c;
      } while (c == ' ' || c == '\t');

      now = &inbuffer[count - 1];

      do {
        c = fgetc (infp);
        inbuffer[count ++] = c;
      } while (!(c == ' ' || c == '\t' || c == '\n'));

      inbuffer[count -1] = 0;
      if (!strcmp (now, "rts"))
        {
          inbuffer [count -1] = c;
          inbuffer [count] = 0;
          ret->body = malloc (count);
          strcpy (ret->body, inbuffer);
          return ret;
        }
      inbuffer [count -1] = c;
    }
}

int
main (int argc, char **argv)
{
  if (argc == 4)
    {
      FUNC *f;
      int num;
      infp = fopen (argv[2], "r");
      if (!infp)
        {
          printf ("Can't Open File %s\n", argv[2]);
          exit (1);
        }
      outfp = fopen (argv[3], "w");
      if (!outfp)
        {
          printf ("Can't Open File %s\n", argv[3]);
          exit (1);
        }
      endlabel = argv[1];
      while (f = get_one_func ())
        {
          if (!samefnc[0])
            {
              samefnc[max_type ++] = f;
              if (max_type == 256)
                abort ();
            }
          else
            {
              int i;
              int found = 0;
              for (i = 0; i < max_type; i++)
                if (!strcmp (samefnc[i] ->body, f->body))
                  {
                    FUNC *next;
                    for (next = samefnc[i]; next->same; next= next->same)
                      ;
                    next->same = f;
                    free (f->body);
                    found = 1;
                    break;
                  }
              if (!found)
                {
                  samefnc[max_type ++] = f;
                  if (max_type == 256)
                    abort ();
                }
	    }
        }
        for (num = 0; num < max_type; num++)
          {
            FUNC *next;
            for (next = samefnc[num]; next; next= next->same)
              {
                fprintf (outfp,"%s", next->head);
                fprintf (outfp,"%s\n", next->label);
              }
            fprintf (outfp,"%s", samefnc[num]->body);
          }
        {
          int c;
          fprintf (outfp,"%s", last_no_out->head);
          fprintf (outfp,"%s\n", last_no_out->label);
          while ((c = fgetc (infp)) != EOF)
            fputc (c,outfp);
        }
      fclose (infp);
      fclose (outfp);
    }
  exit (0);
}
