import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/user_cubit.dart';
import '../bloc/user_state.dart';
import '../widgets/user_shimmer.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<UserCubit>().getUsers();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Search'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<UserCubit>().getUsers(isRefresh: true);
            },
          ),
        ],
      ),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is UserLoading && state.isFirstFetch) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    enabled: false,
                    decoration: const InputDecoration(
                      labelText: 'Search users',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Enter name or email',
                    ),
                  ),
                ),
                const Expanded(child: UserShimmer()),
              ],
            );
          }

          if (state is UserError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 60),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<UserCubit>().getUsers(isRefresh: true);
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<UserCubit>().getUsers(isRefresh: true);
            },
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                // Search Bar
                SliverAppBar(
                  floating: true,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  expandedHeight: 80,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      alignment: Alignment.bottomCenter,
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Search users',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.search),
                          hintText: 'Enter name or email',
                          filled: true,
                          fillColor: Theme.of(context).cardColor,
                        ),
                        onChanged: (value) {
                          context.read<UserCubit>().searchUsers(value);
                        },
                      ),
                    ),
                  ),
                ),

                if (state is UserLoaded) ...[
                  if (state.filteredUsers.isEmpty)
                    const SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off, size: 48, color: Colors.grey),
                            SizedBox(height: 16),
                            Text('No users found', style: TextStyle(fontSize: 16, color: Colors.grey)),
                          ],
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final user = state.filteredUsers[index];
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(user.email),
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: user.gender.toLowerCase() == 'male' ? Colors.blue.withOpacity(0.1) : Colors.pink.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(user.gender, style: TextStyle(color: user.gender.toLowerCase() == 'male' ? Colors.blue : Colors.pink)),
                              ),
                            ),
                          );
                        }, childCount: state.filteredUsers.length),
                      ),
                    ),

                  // Loading and pagination indicators
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          if (state.isLoading) ...[
                            const UserShimmer(),
                          ] else if (state.paginationInfo.currentPage < state.paginationInfo.pages)
                            Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(20)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.arrow_downward, size: 16, color: Colors.grey),
                                    const SizedBox(width: 8),
                                    Text('Scroll to load more', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                                  ],
                                ),
                              ),
                            )
                          else
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(20)),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.check_circle_outline, size: 16, color: Colors.green),
                                  const SizedBox(width: 8),
                                  Text('You\'ve reached the end', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                                ],
                              ),
                            ),
                          const SizedBox(height: 70), // Space for floating page indicator
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
      // Floating page indicator
      floatingActionButton: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is UserLoaded) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(20)),
              child: Text(
                'Page ${state.paginationInfo.currentPage} of ${state.paginationInfo.pages}',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
