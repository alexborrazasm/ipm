import 'package:mockito/mockito.dart';
import 'app_test.mocks.dart';
import 'package:splitwiththemachine/data/models.dart';

MockSplitWithMeService buildMockService() {
  final mockService = MockSplitWithMeService();

  // Configure mock behavior
  when(mockService.fetchFriends()).thenAnswer((_) async => [
    Friend(id: 1, name: "Mock 1", creditBalance: 0, debitBalance: 0),
  ]);


  return mockService;
}
