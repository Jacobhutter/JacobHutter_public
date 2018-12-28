#include "simp_tree.h"

int main(int argc, char *argv[])
{
  if (argc != 2)
  {
    return 0;
  }

  // Opening test file
  FILE *file = fopen(argv[1], "r");
  if (file == NULL)
  {
    return 0;
  }

  // Getting input length
  int len = 0, k = 0;
  fscanf(file, "%d %d\n", &len, &k);

  // Initializing tree
  Node *root = NULL;

  // Reading input
  int input;
  for (int i = 0; i < len; i++)
  {
    fscanf(file, "%d", &input);
    insert_st(&root, input);
  }
  
  // Close file
  fclose(file);

  // Printing tree size
  size_t sz = 0;
  get_size_st(root, &sz);
  printf("Printing tree size:\n");
  printf("%zu\n\n", sz);

  // Printing the tree in pre-order
  printf("Printing pre-order:\n"); 
  print_pre_st(root, stdout);
  printf("\n\n");

  // Printing the tree in in-order
  printf("Printing in-order:\n");
  print_in_st(root, stdout);
  printf("\n\n");

  // Printing the tree in post-order
  printf("Printing post-order:\n");
  print_post_st(root, stdout);
  printf("\n\n");

  // Printing the tree with BFS
  printf("Printing BFS order:\n");
  print_bfs_st(root, stdout);
  printf("\n\n");

  // Printing the tree with DFS
  printf("Printing DFS order:\n");
  print_dfs_st(root, stdout);
  printf("\n\n");

  // Printing the kth level
  printf("Printing Kth (%d) level:\n", k);
  print_level_st(root, k, stdout);
  printf("\n\n");

  // Printing the tree in a zigzag
  printf("Printing tree in a zigzag\n");
  print_zigzag_st(root, stdout);
  printf("\n"); 

  // Free tree
  free_st(root);

  return 0;
}
