import React from "react";
import { PageHeader } from "antd";
import { Layout, Button } from "antd";
import { Auth, API } from "aws-amplify";

const { Content } = Layout;

const LoginPage = () => {
  const username = "matlau";
  const password = "SuperSecretPa55owrd!";

  const handleLoginOnSubmit = async e => {
    e.preventDefault();
    try {
      await Auth.signIn(username, password);
      alert("Logged in");
    } catch (e) {
      alert(e.message);
    }
  };

  const handleCallAPIOnSubmit = async e => {
    e.preventDefault();
    try {
      const res = await API.get("todos", "/todos");
      console.log(res);
    } catch (e) {
      alert(e.message);
    }
  };

  return (
    <div>
      <Content style={{ padding: "0 50px" }}>
        <div className="site-layout-content">
          <PageHeader
            className="site-page-header"
            title="Login"
            style={styles.header}
          />
          <Button onClick={handleLoginOnSubmit}>Login</Button>
          <Button onClick={handleCallAPIOnSubmit}>Call API</Button>
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

export default LoginPage;
