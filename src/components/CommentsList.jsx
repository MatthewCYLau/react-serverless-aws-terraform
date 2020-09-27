import React, { useEffect, useState } from "react";
import { PageHeader, Spin, Card, Input, Button } from "antd";
import { API } from "aws-amplify";
import Likes from "./Likes";

const CommentsList = ({ todoId, username }) => {
  const initialFormState = { content: "" };
  const [formState, setFormState] = useState(initialFormState);
  const [comments, setComments] = useState([]);
  const [loadingComplete, setloadingComplete] = useState(true);
  useEffect(() => {
    fetchComments();
  }, []);

  function setInput(key, value) {
    setFormState({ ...formState, [key]: value });
  }

  async function fetchComments() {
    try {
      const res = await API.get("todos", `/comments?todoId=${todoId}`);
      setComments(res.Items);
      setloadingComplete({ loadingComplete: true });
    } catch (err) {
      console.log("error fetching comments");
    }
  }

  async function addComment() {
    try {
      if (!formState.content) return;
      const comment = {
        ...formState,
        todoId,
        username
      };
      setFormState(initialFormState);

      const config = {
        body: comment,
        headers: {
          "Content-Type": "application/json"
        }
      };
      await API.post("todos", "/comments", config);
      fetchComments();
    } catch (err) {
      console.log("error creating comment:", err);
    }
  }

  async function removeComment(id) {
    try {
      setComments(comments.filter(comment => comment.commentId.S !== id));
      await API.del("todos", `/comments/${id}`);
    } catch (err) {
      console.log("error removing comment:", err);
    }
  }

  return (
    <div>
      <PageHeader
        className="site-page-header"
        title="Comments"
        style={styles.header}
      />
      <div>
        <Input
          onChange={event => setInput("content", event.target.value)}
          value={formState.content}
          placeholder="Comment"
          style={styles.input}
        />
        <Button onClick={addComment} type="primary" style={styles.submit}>
          Add
        </Button>
      </div>
      {loadingComplete ? (
        <div>
          {comments.map((comment, index) => (
            <Card
              key={comment.commentId ? comment.commentId.S : index}
              title={comment.content.S}
              style={{ width: 300 }}
            >
              <p>{comment.username.S}</p>
              {comment.username.S === username && (
                <Button
                  type="primary"
                  onClick={() => removeComment(comment.commentId.S)}
                >
                  Delete
                </Button>
              )}
              <Likes commentId={comment.commentId.S} username={username} />
            </Card>
          ))}
        </div>
      ) : (
        <Spin />
      )}
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

export default CommentsList;
