/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License,Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import { relationalStore } from '@kit.ArkData';
import CommonConstants from '../../constants/CommonConstants';
import Rdb from '../Rdb';
import UsersData from '../../../viewmodel/UsersData'

export default class UsersTable {
  private usersTable = new Rdb(CommonConstants.USERS_TABLE.tableName, CommonConstants.USERS_TABLE.sqlCreate,
    CommonConstants.USERS_TABLE.columns);

  constructor(callback: Function = () => {}) {
    this.usersTable.getRdbStore(callback);
  }

  getRdbStore(callback: Function = () => {}) {
    this.usersTable.getRdbStore(callback);
  }

  insertData(username: string, email: string, callback: Function) {
    const valueBucket: relationalStore.ValuesBucket = {
      username: username,
      email: email
    };
    this.usersTable.insertData(valueBucket, callback);
  }

  deleteData(userId: number, callback: Function) {
    let predicates = new relationalStore.RdbPredicates(CommonConstants.USERS_TABLE.tableName);
    predicates.equalTo('id', userId);
    this.usersTable.deleteData(predicates, callback);
  }

  updateData(userId: number, username: string, email: string, callback: Function) {
    const valueBucket: relationalStore.ValuesBucket = {
      username: username,
      email: email
    };
    let predicates = new relationalStore.RdbPredicates(CommonConstants.USERS_TABLE.tableName);
    predicates.equalTo('id', userId);
    this.usersTable.updateData(predicates, valueBucket, callback);
  }

  queryUsers(username: string, callback: Function, isAll: boolean = true) {
    let predicates = new relationalStore.RdbPredicates(CommonConstants.USERS_TABLE.tableName);
    if (!isAll) {
      predicates.equalTo('username', username);
    }
    this.usersTable.query(predicates, (resultSet: relationalStore.ResultSet) => {
      let count: number = resultSet.rowCount;
      if (count === 0 || typeof count === 'string') {
        console.log(`${CommonConstants.USERS_TABLE_TAG}` + 'Query no results!');
        callback([]);
      } else {
        resultSet.goToFirstRow();
        const result: UsersData[] = [];
        for (let i = 0; i < count; i++) {
          const tmp = new UsersData(
            resultSet.getDouble(resultSet.getColumnIndex('id')),
            resultSet.getString(resultSet.getColumnIndex('username')),
            resultSet.getString(resultSet.getColumnIndex('email'))
          );
          result[i] = tmp;
          resultSet.goToNextRow();
        }
        callback(result);
      }
    });
  }

  registerUser(username: string, email: string, callback: Function) {
    const valueBucket: relationalStore.ValuesBucket = {
      username: username,
      email: email,
    };
    this.usersTable.insertData(valueBucket, callback);
  }

  loginUser(username: string, email: string, callback: Function) {
    let predicates = new relationalStore.RdbPredicates(CommonConstants.USERS_TABLE.tableName);
    predicates.equalTo('username', username);
    predicates.equalTo('email', email);

    this.usersTable.query(predicates, (resultSet: relationalStore.ResultSet) => {
      let count: number = resultSet.rowCount;
      if (count === 0) {
        // 用户名和电子邮件组合不存在
        callback(false, null);
      } else {
        // 找到用户
        resultSet.goToFirstRow();
        const userData = new UsersData(
          resultSet.getDouble(resultSet.getColumnIndex('id')),
          resultSet.getString(resultSet.getColumnIndex('username')),
          resultSet.getString(resultSet.getColumnIndex('email'))
        );
        callback(true, userData); // 登录成功，返回用户信息
      }
    });
  }



}
