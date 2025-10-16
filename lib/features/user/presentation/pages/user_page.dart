import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/routes/routes.dart';
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
      backgroundColor: Colors.grey[50],
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.blue.shade800, Colors.blue.shade600]),
          ),
        ),
        title: const Text(
          'User Management',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              context.read<UserCubit>().getUsers(isRefresh: true);
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[50],
          image: DecorationImage(
            image: NetworkImage('https://transparenttextures.com/patterns/subtle-white-feathers.png'),
            repeat: ImageRepeat.repeat,
            opacity: 0.5,
          ),
        ),
        child: BlocBuilder<UserCubit, UserState>(
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
              child: SafeArea(
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    // Search Bar
                    PinnedHeaderSliver(
                      child: Container(
                        margin: const EdgeInsets.all(16.0),

                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 1))],
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            border: InputBorder.none,
                            hintText: 'Search users by name or email',
                            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 15),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(left: 16, right: 8),
                              child: Icon(Icons.search_rounded, color: Colors.grey.shade400, size: 24),
                            ),
                            prefixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                          ),
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                          onChanged: (value) {
                            context.read<UserCubit>().searchUsers(value);
                          },
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
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(color: Colors.grey.withOpacity(0.08), spreadRadius: 2, blurRadius: 10, offset: const Offset(0, 2)),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(user.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                            const SizedBox(height: 4),
                                            Text(user.email, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: user.gender.toLowerCase() == 'male' ? Colors.blue.withOpacity(0.1) : Colors.pink.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(24),
                                        ),
                                        child: Text(
                                          user.gender,
                                          style: TextStyle(
                                            color: user.gender.toLowerCase() == 'male' ? Colors.blue.shade700 : Colors.pink.shade700,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ],
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
              ),
            );
          },
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.blue.shade300.withOpacity(0.3), spreadRadius: 2, blurRadius: 10, offset: const Offset(0, 2))],
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.blue.shade600, Colors.blue.shade800]),
            borderRadius: BorderRadius.circular(16),
          ),
          child: FloatingActionButton.extended(
            heroTag: 'add_user',
            backgroundColor: Colors.transparent,
            elevation: 0,
            onPressed: () async {
              final result = await Navigator.pushNamed(context, Routes.registerUser);
              if (result == true) {
                // ignore: use_build_context_synchronously
                context.read<UserCubit>().getUsers(isRefresh: true);
              }
            },
            extendedPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            extendedIconLabelSpacing: 12,
            icon: const Icon(Icons.person_add_rounded, color: Colors.white),
            label: const Text(
              'Add User',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
            ),
            isExtended: true,
          ),
        ),
      ),
    );
  }
}
