#include <stdio.h>
/*#include <stdlib.h> // Only required for larger inputs. */

#define BLANKET_WIDTH 1000
#define BLANKET_HEIGHT 1000
#define MAX_PIECES 2000

typedef struct {
    int id1;
    int id2;
} Location;

int main(int argc, char *argv[]) {
    FILE *fd;
    char buf[50];
    Location blanket[BLANKET_HEIGHT][BLANKET_WIDTH] = {0};
    Location *l;
    int id, from_left, from_top, width, height;
    int double_ct = 0;
    int candidates[MAX_PIECES] = {0};

    /* // This is required for larger inputs. In such case, delete the previous declaration.
    Location *blanket[BLANKET_HEIGHT];
    for (int i = 0; i < BLANKET_HEIGHT; ++i) {
        blanket[i] = calloc(BLANKET_WIDTH, sizeof(Location));
        if (blanket[i] == NULL) {
            fprintf(stderr, "Could not allocate memory for blanket.\n");
            return 1;
        }
    }
    */

    if (argc != 2) {
        fprintf(stderr, "Usage: %s [inputfile]\n", argv[0]);
        return 2;
    }

    fd = fopen(argv[1], "r");
    if (fd == NULL) {
        fprintf(stderr, "Could not open the input file.\n");
        return 1;
    }

    while (fscanf(fd, "#%d @ %d,%d: %dx%d\n", &id, &from_left, &from_top, &width, &height) == 5) {
        for (int i = 0; i < width; ++i) {
            for (int j = 0; j < height; ++j) {
                l = &blanket[from_left + i][from_top + j];
                if (l->id1) {
                    candidates[id - 1] = candidates[l->id1 - 1] = 1;
                    if (!l->id2) {
                        l->id2 = id;
                        ++double_ct;
                    }
                } else {
                    l->id1 = id;
                }
            }
        }

    }

    fclose(fd);

    /* // See above.
    for (int i = 0; i < BLANKET_HEIGHT; ++i)
        free(blanket[i]);
    */

    while (candidates[--id] == 1)
        ;

    printf("Part 1: %d\nPart 2: %d\n", double_ct, id + 1);
    return 0;
}
