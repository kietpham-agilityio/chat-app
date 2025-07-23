import 'package:chat_app/models/conversation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ConversationRepository {
  ConversationRepository({Supabase? supabase})
    : _supabase = supabase ?? Supabase.instance;

  final Supabase _supabase;

  RealtimeChannel? _convoChannel;
  RealtimeChannel? _memberChannel;
  RealtimeChannel? _profileChannel;

  void listenToRelatedTables({
    required String userId,
    required void Function() onChanged,
  }) {
    _convoChannel?.unsubscribe();
    _memberChannel?.unsubscribe();
    _profileChannel?.unsubscribe();

    _convoChannel = _supabase.client.channel('public:conversations')
      ..onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: 'conversations',
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'user_id',
          value: userId,
        ),
        callback: (_) => onChanged(),
      )
      ..subscribe();

    _memberChannel = _supabase.client.channel('public:conversation_members')
      ..onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: 'conversation_members',
        filter: PostgresChangeFilter(
          column: 'user_id',
          type: PostgresChangeFilterType.eq,
          value: userId,
        ),
        callback: (_) => onChanged(),
      )
      ..subscribe();

    _profileChannel = _supabase.client.channel('public:profiles')
      ..onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: 'profiles',
        callback: (_) => onChanged(),
      )
      ..subscribe();
  }

  Future<List<Conversation>> fetchUserConversations(String userId) async {
    final data = await _supabase.client
        .from('one_to_one_conversations')
        .select()
        .eq('current_user_id', userId);

    return (data as List)
        .map((e) => Conversation.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  void unsubscribe() {
    _convoChannel?.unsubscribe();
    _memberChannel?.unsubscribe();
    _profileChannel?.unsubscribe();
    _convoChannel = null;
    _memberChannel = null;
    _profileChannel = null;
  }
}
