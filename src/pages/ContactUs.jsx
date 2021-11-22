import React from "react";
import { PageHeader } from "antd";
import { Layout } from "antd";
import { useState } from 'react';
import ReactDOM from 'react-dom';
import 'antd/dist/antd.css';
import '../index.css';
import { Form, Input, Button} from 'antd';


const { Content } = Layout;




const ContactUs = () => {
    const [form] = Form.useForm();
    const [requiredMark, setRequiredMarkType] = useState('optional');
      
    const onRequiredTypeChange = ({ requiredMarkValue }) => {
        setRequiredMarkType(requiredMarkValue);
    };



  return (
    <div>
      <Content style={{ padding: "0 50px" }}>

        <div className="site-layout-content">
          <PageHeader
            className="site-page-header"
            title="Contact Us"
            style={styles.header}
          />
        </div>

        <div>
            <Form
            form={form}
            layout="vertical"
            initialValues={{
                requiredMarkValue: requiredMark,
            }}
            onValuesChange={onRequiredTypeChange}
            requiredMark={requiredMark}
            >

            <Form.Item label="Name" required tooltip="This is a required field">
                <Input placeholder="Type your name here" />
            </Form.Item>

            <Form.Item
                label="Email"
                required
                tooltip={{
                title: 'This is a required field',
                }}
            >
            <Input placeholder="Type your email here" />
            </Form.Item>

            <Form.Item label="Query" required tooltip="This is a required field">
                <Input placeholder="Type your query here" />
            </Form.Item>

            <Form.Item>
                <Button type="primary">Submit</Button>
            </Form.Item>
            </Form>
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

export default ContactUs;