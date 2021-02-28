#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <time.h>

#define TOTAL_FILES 100
#define TICKS 30

char* levels[3] = {"weak", "media", "strong"};
typedef enum { WEAK, MEDIUM, STRONG } level_t;
FILE* f;

int get_rand_interval(level_t level, int intervals[3][2]) {
  return (rand() % (intervals[level][1] - intervals[level][0]) + 1) + intervals[level][0];
}

void gen(level_t is_level, level_t cancer_level) {
  int is_intervals[3][2] = {{41, 79}, {40, 85}, {55,94}};
  int cancer_intervals[3][2] = {{38, 75}, {40, 83}, {55,95}};
  int age_intervals[3][2] = {{5, 7}, {6, 8}, {7, 9}};
  int prob_change_neut_macr = (int) (((float)(is_level+1) / (float)(is_level+1 + cancer_level + 1)) * 100);

  fprintf(f, "No.-of-initial-tumor-cells,%d\n", get_rand_interval(cancer_level, cancer_intervals));
  fprintf(f, "No.-of-initial-neutrophils-cell,%d\n", (get_rand_interval(is_level, is_intervals) * 2));
  fprintf(f, "No.-of-initial-macrophages-cells,%d\n", (get_rand_interval(is_level, is_intervals) * 2));
  fprintf(f, "No.-of-initial-natural-killers-cells,%d\n", get_rand_interval(is_level, is_intervals));

  fprintf(f, "tumor-growth-factor,%d\n", get_rand_interval(cancer_level, cancer_intervals));

  fprintf(f, "recruit-natural-killers,%d\n", get_rand_interval(is_level, is_intervals));
  fprintf(f, "SAttackSuccesByNk,%d\n", get_rand_interval(is_level, is_intervals));

  fprintf(f, "recruit-macrophages,%d\n", get_rand_interval(is_level, is_intervals));
  fprintf(f, "SuccesOfInterac-MacrTum,%d\n", get_rand_interval(is_level, is_intervals));
  fprintf(f, "SuccesOf-tam1,%d\n", get_rand_interval(is_level, is_intervals));
  fprintf(f, "Change-to-tam1-or-tam2,%d\n", prob_change_neut_macr);
  fprintf(f, "No-of-activating-tumor-cells-by-tam2,%d\n", get_rand_interval(cancer_level, cancer_intervals));
  fprintf(f, "No-of-deactivating-tumor-cells-by-tam1,%d\n", get_rand_interval(is_level, is_intervals));

  fprintf(f, "recruit-neutrophils,%d\n", get_rand_interval(is_level, is_intervals));
  fprintf(f, "SuccesOfInterac-NeutTum,%d\n", get_rand_interval(is_level, is_intervals));
  fprintf(f, "SuccesOf-tan1,%d\n", get_rand_interval(is_level, is_intervals));
  fprintf(f, "Change-to-tan1-or-tan2,%d\n", prob_change_neut_macr);
  fprintf(f, "No-of-activating-tumor-cells-by-tan2,%d\n", get_rand_interval(cancer_level, cancer_intervals));
  fprintf(f, "No-of-deactivating-tumor-cells-by-tan1,%d\n", get_rand_interval(is_level, is_intervals));

  fprintf(f, "max-age-tam1,%d\n", get_rand_interval(is_level, age_intervals));
  fprintf(f, "max-age-tam2,%d\n", get_rand_interval(is_level, age_intervals));
  fprintf(f, "max-age-tan1,%d\n", get_rand_interval(is_level, age_intervals));
  fprintf(f, "max-age-tan2,%d\n", get_rand_interval(is_level, age_intervals));
  fprintf(f, "max-age-nk,%d\n", get_rand_interval(is_level, age_intervals));

  fprintf(f, "max-tumors,5000\n");
  
  // int diff_level = abs(is_level - cancer_level);
  // if (diff_level == 2) {
  //   fprintf(f, "No.ticks,%d\n", 20);
  // } else if (diff_level == 1) {
  //   fprintf(f, "No.ticks,%d\n", 25);
  // } else if (diff_level == 0) {
  //   fprintf(f, "No.ticks,%d\n", 30);
  // }
  fprintf(f, "No.ticks,%d\n", TICKS);

  fprintf(f, "No.-of-initial-t-cells,%d\n", get_rand_interval(is_level, is_intervals));
  fprintf(f, "recruit-t-cells,%d\n", get_rand_interval(is_level, is_intervals));
  fprintf(f, "SuccesOfInterac-tCells-tumor,%d\n", get_rand_interval(is_level, is_intervals));
  fprintf(f, "max-age-t-cell,%d\n", get_rand_interval(is_level, age_intervals));
  fprintf(f, "AttackSuccesByTCells,%d\n", get_rand_interval(is_level, is_intervals));

  fprintf(f, "No.-of-initial-treg-cells,%d\n", get_rand_interval(is_level, is_intervals));
  fprintf(f, "recruit-treg-cells,%d\n", get_rand_interval(is_level, is_intervals));
  fprintf(f, "SuccesOfInterac-tregCells-tCells,%d\n", get_rand_interval(is_level, is_intervals));
  fprintf(f, "SuccesOfInterac-tregCells-thCells,%d\n", get_rand_interval(is_level, is_intervals));
  fprintf(f, "max-age-treg-cell,%d\n", get_rand_interval(is_level, age_intervals));

  fprintf(f, "No.-of-initial-th-cells,%d\n", get_rand_interval(is_level, is_intervals));
  fprintf(f, "recruit-th-cells,%d\n", get_rand_interval(is_level, is_intervals));
  fprintf(f, "SuccesOfInterac-thCells-tCells,%d\n", get_rand_interval(is_level, is_intervals));
  fprintf(f, "max-age-th-cell,%d\n", get_rand_interval(is_level, age_intervals));
}

void gen_data_by_combination(level_t is_level, level_t cancer_level) {
  char folder[100], filename[100];

  sprintf(folder, "%s-%s", levels[is_level], levels[cancer_level]);
  mkdir(folder, 0755);

  for (int i = 1; i <= TOTAL_FILES; i++) {
    sprintf(filename, "%s/input_values%d.csv", folder, i);
    f = fopen(filename, "w");

    if (f == NULL) {
      fprintf(stderr, "Error en la creacioin del archivo %s.\n", filename);
      break;
    } else {
      gen(is_level, cancer_level);
    }
    fclose(f);
  }
}

void gen_data() {
  for (size_t i = 0; i < 3; i++) {
    for (size_t j = 0; j < 3; j++) {
      gen_data_by_combination(i, j);
    }
  }
}

int main() {
  srand(time(NULL));

  gen_data();

  return 0;
}
