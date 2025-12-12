import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/provider/sensing/account_resp.dart';
import '../../../common_widgets/async_value_widget.dart';
import '../../../config/style.dart';
import '../../home/presentation/base_screen.dart';
import '../../manage_building/presentation/add_building_dialog.dart';
import '../controller/account_list_view_model.dart';

class AccountListScreen extends ConsumerStatefulWidget {
  const AccountListScreen({super.key});

  @override
  ConsumerState<AccountListScreen> createState() => _AccountListScreenState();
}

class _AccountListScreenState extends ConsumerState<AccountListScreen> {
  DateTime _lastUpdatedTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return AsyncProviderWidget(
      provider: accountListViewModelProvider,
      data: (user) {
        UserListResponse data = user as UserListResponse;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: [
              topTitle('Account List', 'Manage system administrators and roles.', _lastUpdatedTime, () {
                setState(() {
                  _lastUpdatedTime = DateTime.now();
                });
              }),
              // Filter bar
              Container(
                width: MediaQuery.of(context).size.width - 240,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                color: Colors.white,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isNarrow = constraints.maxWidth < 1100;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              const Text('Total '),
                              const SizedBox(width: 8),
                              const CircleAvatar(
                                radius: 12,
                                backgroundColor: Colors.amber,
                                child: Text('89', style: TextStyle(fontSize: 12)),
                              ),
                              const SizedBox(width: 16),
                              _filterTab('New', 0),
                              const SizedBox(width: 8),
                              _filterTab('Locked', 0),
                              const SizedBox(width: 8),
                              _filterTab('Expired', 2),
                              const SizedBox(width: 8),
                              _filterTab('Deleted', 0),
                              SizedBox(width: MediaQuery.of(context).size.width - 1350 > 0 ? MediaQuery.of(context).size.width - 1350 : 0),

                              ElevatedButton(
                                onPressed: () {},
                                child: isNarrow ? const Icon(Icons.lock_reset) : const Text('Reset Password'),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () {},
                                child: isNarrow ? const Icon(Icons.manage_accounts) : const Text('User management'),
                              ),
                              const SizedBox(width: 8),
                              InkWell(
                                onTap: () {},
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), color: themeYellow),
                                  child: Row(
                                    children: [
                                      Icon(Icons.add, color: commonWhite),
                                      isNarrow
                                          ? Container()
                                          : Row(children: [const SizedBox(width: 4), Text('Add Building', style: bodyCommon(commonWhite))]),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              Expanded(
                child: SizedBox(
                  height: data.content.length * 20,
                  child: ListView.builder(
                    itemCount: data.content.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        height: 32,
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 0.5)),
                        alignment: Alignment.center,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              const SizedBox(width: 60),
                              SizedBox(width: 240, child: Text(data.content[index].email)),
                              const SizedBox(width: 40),
                              SizedBox(width: 100, child: Text(data.content[index].status.toString())),
                              const SizedBox(width: 40),
                              SizedBox(width: 200, child: Text(data.content[index].signInDate.toString())),
                              const SizedBox(width: 40),
                              SizedBox(width: 60, child: Text(data.content[index].pairedNum.toString())),
                              const SizedBox(width: 40),
                              SizedBox(width: 200, child: Text(data.content[index].memo.toString())),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _filterTab(String label, int count) {
    return IntrinsicWidth(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisSize: MainAxisSize.min, // 핵심: 최소한의 너비만 차지
          children: [
            Text(label),
            const SizedBox(width: 6),
            CircleAvatar(radius: 10, backgroundColor: Colors.white, child: Text(count.toString(), style: const TextStyle(fontSize: 12))),
          ],
        ),
      ),
    );
  }
}
