import React from "react";
import { PageHeader } from "antd";
import { Layout } from "antd";
import { Typography, Space } from 'antd';

const { Content } = Layout;
const { Text, Link } = Typography;

const AboutPage = () => {
  return (
    <div>
      <Content style={{ padding: "0 50px" }}>
        <div className="site-layout-content">
          <PageHeader
            className="site-page-header"
            title="About"
            style={styles.header}
          />
          <Space direction="vertical">
          <Text>We are Mattdera, a small tech startup in Manchester. Our goal — to help you get <Text strong>organised!!!</Text></Text>
          <Text>Our revolutionary app will help you achieve all your hopes and dreams and help you makes loads of money.🤑</Text>
          <Text>Some of our amazing features include</Text>
          <ul>
            <li><Text>You can add to-do items.</Text></li>
            <li><Text>Add descriptions for your tasks.</Text></li>
            <li><Text>Comment on your friends goals.</Text></li>
            <li><Text>Like others comments.</Text></li>
          </ul>
          <Text>Contact us about any additional features you want to see and give our repo a star on <Link href="https://github.com/MatthewCYLau/react-serverless-aws-terraform" target="_blank">Github.</Link></Text>
          </Space>
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

export default AboutPage;
