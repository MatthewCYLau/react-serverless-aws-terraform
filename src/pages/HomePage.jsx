import React, { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { PageHeader } from "antd";
import { Card, Button, Input } from "antd";
import "antd/dist/antd.css";
import { Layout, Spin } from "antd";

const { Content } = Layout;

const HomePage = () => {
  return (
    <div>
      <Content style={{ padding: "0 50px" }}>
        <div className="site-layout-content">
          <PageHeader
            className="site-page-header"
            title={"Welcome"}
            subTitle="To-do list powered by AWS serverless architecture"
            style={styles.header}
          />
        </div>
      </Content>
    </div>
  );
};

const styles = {
  input: {
    margin: "10px 0"
  },
  submit: {
    margin: "10px 0",
    marginBottom: "20px"
  },
  header: {
    paddingLeft: "0px"
  }
};

export default HomePage;
