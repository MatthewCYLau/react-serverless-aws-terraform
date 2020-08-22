import React, { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { PageHeader } from "antd";
import { Card, Button, Input } from "antd";
import "antd/dist/antd.css";
import { Layout, Spin } from "antd";
import axios from "axios";

const { Content } = Layout;

const HomePage = () => {
  const loadingState = false;
  const [todos, setTodos] = useState([]);
  const [loadingComplete, setloadingComplete] = useState(loadingState);

  useEffect(() => {
    fetchTodos();
  }, []);

  async function fetchTodos() {
    try {
      const res = await axios.get(
        `https://j7sphw5bq4.execute-api.us-east-1.amazonaws.com/test/todos`
      );
      setTodos(res.data.Items);
      setloadingComplete({ loadingComplete: true });
    } catch (err) {
      console.log("error fetching todos");
    }
  }

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
        {loadingComplete ? (
          <div>
            {todos.map((todo, index) => (
              <Card key={todo.id.S} title={todo.name.S} style={{ width: 300 }}>
                <p>{todo.description.S}</p>
              </Card>
            ))}
          </div>
        ) : (
          <Spin />
        )}
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
