import React from "react";
import { Layout } from "antd";
const { Footer } = Layout;

const AppFooter = () => (
  <Footer style={{ textAlign: "center" }}>Matthew Lau ©{new Date().getFullYear()}</Footer>
);

export default AppFooter;
