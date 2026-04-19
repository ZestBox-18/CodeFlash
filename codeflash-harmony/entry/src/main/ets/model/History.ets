import { dbManager } from 'kite_utils';
import { relationalStore } from '@kit.ArkData';

@ObservedV2
export class HistoryItem {
  @Trace id: number = 0;
  @Trace type: 'push' | 'pull' = 'push';
  @Trace content: string = '';
  @Trace timestamp: number = 0;
  @Trace device: string = '';

  constructor(id: number, type: 'push' | 'pull', content: string, timestamp: number, device: string) {
    this.id = id;
    this.type = type;
    this.content = content;
    this.timestamp = timestamp;
    this.device = device;
  }
}

export class HistoryManager {
  static readonly TABLE_NAME = 'history';
  static readonly MAX_HISTORY = 50;

  static async add(type: 'push' | 'pull', content: string, device: string): Promise<HistoryItem[]> {
    if (!dbManager.dbStore) {
      console.error('Database not initialized');
      return [];
    }

    const valueBucket: relationalStore.ValuesBucket = {
      type: type,
      content: content,
      timestamp: Date.now(),
      device: device
    };

    try {
      await dbManager.dbStore.insert(HistoryManager.TABLE_NAME, valueBucket);
    } catch (e) {
      console.error('Insert failed:', e);
    }
    
    return await HistoryManager.getAll();
  }

  static async getAll(): Promise<HistoryItem[]> {
    if (!dbManager.dbStore) {
      return [];
    }

    const predicates = new relationalStore.RdbPredicates(HistoryManager.TABLE_NAME);
    predicates.orderByDesc('timestamp');
    predicates.limitAs(HistoryManager.MAX_HISTORY);

    try {
      const resultSet = await dbManager.dbStore.query(predicates);
      const list: HistoryItem[] = [];
      while (resultSet.goToNextRow()) {
        list.push(new HistoryItem(
          resultSet.getLong(resultSet.getColumnIndex('id')),
          resultSet.getString(resultSet.getColumnIndex('type')) as 'push' | 'pull',
          resultSet.getString(resultSet.getColumnIndex('content')),
          resultSet.getLong(resultSet.getColumnIndex('timestamp')),
          resultSet.getString(resultSet.getColumnIndex('device'))
        ));
      }
      resultSet.close();
      return list;
    } catch (e) {
      console.error('Query failed:', e);
      return [];
    }
  }

  static async delete(id: number): Promise<HistoryItem[]> {
    if (!dbManager.dbStore) return [];
    
    const predicates = new relationalStore.RdbPredicates(HistoryManager.TABLE_NAME);
    predicates.equalTo('id', id);
    
    try {
      await dbManager.dbStore.delete(predicates);
    } catch (e) {
      console.error('Delete failed:', e);
    }
    return await HistoryManager.getAll();
  }

  static async clear(): Promise<HistoryItem[]> {
    if (!dbManager.dbStore) return [];
    
    const predicates = new relationalStore.RdbPredicates(HistoryManager.TABLE_NAME);
    
    try {
      await dbManager.dbStore.delete(predicates);
    } catch (e) {
      console.error('Clear failed:', e);
    }
    return [];
  }
}
