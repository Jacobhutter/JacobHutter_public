#ifndef SIMP_TREE_H
#define SIMP_TREE_H

#include "error.h"
#include "node.h"

/* PUBLIC FUNCTIONS */
Handle insert_st(Node **nd, int val);
Handle get_size_st(Node *nd, size_t *sz);
Handle print_pre_st(Node *nd, FILE *stream);
Handle print_in_st(Node *nd, FILE *stream);
Handle print_post_st(Node *nd, FILE *stream);
Handle print_bfs_st(Node *nd, FILE *stream);
Handle print_dfs_st(Node *nd, FILE *stream);
Handle print_level_st(Node *nd, int k, FILE *stream);
Handle print_zigzag_st(Node *nd, FILE *stream);
Handle free_st(Node *nd);

/* PRIVATE FUNCTIONS */
void _print_node(Node *nd, FILE *stream);

#endif /* SIMP_TREE_H */
